#!/usr/bin/env python3
import os
import sys
import argparse


def parse_modules_dep(path: str):
    deps_map = {}
    try:
        with open(path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or ':' not in line:
                    continue
                left, right = line.split(':', 1)
                left = left.strip()
                base = os.path.basename(left)
                deps = []
                right = right.strip()
                if right:
                    for tok in right.split():
                        deps.append(os.path.basename(tok))
                # Map by basename and by full path for convenience
                deps_map[base] = deps
                deps_map[left] = deps
    except FileNotFoundError:
        print(f"无法打开依赖文件: {path}", file=sys.stderr)
        sys.exit(1)
    return deps_map


def normalize_module_name(name: str) -> str:
    return os.path.basename(name.strip())


def compute_closure(deps_map, roots):
    visited = set()
    order = []
    temp = set()

    def dfs(node):
        n = normalize_module_name(node)
        if n in temp:
            # 循环依赖保护，直接返回
            return
        if n in visited:
            return
        temp.add(n)
        for dep in deps_map.get(n, []):
            dfs(dep)
        temp.remove(n)
        visited.add(n)
        order.append(n)

    for r in roots:
        dfs(r)

    return visited, order  # visited: 唯一集合, order: 依赖在前的拓扑顺序


def main():
    ap = argparse.ArgumentParser(description="从 modules.dep 计算模块的完整依赖链（唯一集合与加载顺序）")
    ap.add_argument('modules', nargs='+', help='模块名或路径（例如 nxp-nci.ko）')
    ap.add_argument('--dep-file', default='modules.dep', help='modules.dep 文件路径')
    ap.add_argument('--per-module', action='store_true', help='同时打印每个模块独立的依赖闭包')
    args = ap.parse_args()

    deps_map = parse_modules_dep(args.dep_file)
    roots = [normalize_module_name(m) for m in args.modules]

    visited, order = compute_closure(deps_map, roots)

    print("目标模块:", ' '.join(roots))
    print(f"依赖唯一集合({len(visited)}项):")
    print(' '.join(sorted(visited)))
    print(f"建议加载顺序({len(order)}步):")
    print(' '.join(order))

    if args.per_module:
        print("\n-- 每个模块的依赖链 --")
        for r in roots:
            v, o = compute_closure(deps_map, [r])
            print("模块:", r)
            print(f"集合({len(v)}):", ' '.join(sorted(v)))
            print(f"顺序({len(o)}):", ' '.join(o))
            print()


if __name__ == '__main__':
    main()