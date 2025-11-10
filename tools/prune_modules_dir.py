#!/usr/bin/env python3
import os
import sys
import argparse
from typing import Set, List, Tuple


def parse_modules_dep(path: str):
    deps_map = {}
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
                deps = [os.path.basename(tok) for tok in right.split()]
            deps_map[base] = deps
            deps_map[left] = deps
    return deps_map


def normalize(name: str) -> str:
    return os.path.basename(name.strip())


def compute_closure(deps_map, roots: List[str]) -> Tuple[Set[str], List[str]]:
    visited: Set[str] = set()
    order: List[str] = []
    temp: Set[str] = set()

    def dfs(node: str):
        n = normalize(node)
        if n in temp:
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
    return visited, order


def main():
    ap = argparse.ArgumentParser(description='在指定模块目录中，仅保留所需模块（根据 modules.dep 依赖闭包）')
    ap.add_argument('--dir', required=True, help='目标模块目录，例如 recovery/root/vendor/.../vendor/lib/modules/1.1')
    ap.add_argument('modules', nargs='+', help='顶层模块名，例如 synaptics_tcm2.ko')
    ap.add_argument('--dep-file', help='modules.dep 路径，默认取 --dir 下的 modules.dep，若不存在则回退到项目根')
    ap.add_argument('--dry-run', action='store_true', help='仅显示将删除的文件，不实际删除')
    args = ap.parse_args()

    moddir = args.dir
    dep_file = args.dep_file
    if not dep_file:
        candidate = os.path.join(moddir, 'modules.dep')
        if os.path.exists(candidate):
            dep_file = candidate
        else:
            dep_file = 'modules.dep'

    if not os.path.isdir(moddir):
        print(f'目录不存在: {moddir}', file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(dep_file):
        print(f'依赖文件不存在: {dep_file}', file=sys.stderr)
        sys.exit(1)

    deps_map = parse_modules_dep(dep_file)
    roots = [normalize(m) for m in args.modules]
    keep_set, order = compute_closure(deps_map, roots)

    print('顶层模块:', ' '.join(roots))
    print(f'依赖闭包集合({len(keep_set)}):', ' '.join(sorted(keep_set)))
    print(f'加载顺序({len(order)}):', ' '.join(order))

    # 额外保留的非 .ko 元数据文件
    meta_files = {'modules.dep', 'modules.alias', 'modules.softdep', 'modules.load'}

    delete_list = []
    for entry in os.listdir(moddir):
        full = os.path.join(moddir, entry)
        if os.path.isdir(full):
            continue
        if entry in meta_files:
            continue
        if entry.endswith('.ko'):
            if entry not in keep_set:
                delete_list.append(full)

    print(f'待删除 .ko 文件数: {len(delete_list)}')
    if args.dry_run:
        for p in delete_list:
            print('[DRY] 删除:', p)
        return

    for p in delete_list:
        try:
            os.remove(p)
            print('删除:', p)
        except Exception as e:
            print(f'删除失败 {p}: {e}', file=sys.stderr)


if __name__ == '__main__':
    main()