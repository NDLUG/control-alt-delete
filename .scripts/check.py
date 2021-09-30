#!/usr/bin/env python3

import glob
import json
import os
import sys

import requests
import yaml

# Globals

ASSIGNMENTS     = {}
DREDD_CODE_URL  = f'https://dredd.h4x0r.space/code/control-alt-delete/'

# Utilities

def add_assignment(assignment, path=None):
    assignment = assignment.split('-')[0]

    if path is None:
        path = assignment

    if assignment.startswith('challenge'):
        ASSIGNMENTS[assignment] = path

def print_results(results, print_status=True):
    for key, value in sorted(results.items()):
        if key in ('score', 'status', 'value'):
            continue

        try:
            print('{:>8} {:.2f}'.format(key.title(), value))
        except ValueError:
            if key in ('stdout', 'diff'):
                print('{:>8}\n{}'.format(key.title(), value))
            else:
                print('{:>8} {}'.format(key.title(), value))

    print('{:>8} {:.2f} / {:.2f}'.format('Score', results.get('score', 0), results.get('value', 0)))
    if print_status:
        print('{:>8} {}'.format('Status', 'Success' if int(results.get('status', 1)) == 0 else 'Failure'))

# Check Functions

def check_code(assignment, path):
    sources = glob.glob(os.path.join(path, 'solution*.*'))

    if not sources:
        print('No code found (solution*.*)')
        return 1

    result = 1
    for source in sources:
        print('\nChecking {} {} ...'.format(assignment, os.path.basename(source)))
        response = requests.post(DREDD_CODE_URL + assignment, files={'source': open(source)})
        print_results(response.json(), False)

        result = min(result, response.json().get('status', 1))
    return result

# Main Execution

def main():
    # Add GitLab/GitHub branch
    for variable in ['CI_BUILD_REF_NAME', 'GITHUB_HEAD_REF']:
        try:
            add_assignment(os.environ[variable])
        except KeyError:
            pass

    # Add local git branch
    try:
        add_assignment(os.popen('git symbolic-ref -q --short HEAD 2> /dev/null').read().strip())
    except OSError:
        pass

    # Add current directory
    add_assignment(os.path.basename(os.path.abspath(os.curdir)), os.curdir)

    # For each assignment, submit quiz answers and program code

    if not ASSIGNMENTS:
        print('Nothing to submit!')
        sys.exit(1)

    exit_code = 0

    for assignment, path in sorted(ASSIGNMENTS.items()):
        exit_code += check_code(assignment, path)

    sys.exit(exit_code)

# vim: set sts=4 sw=4 ts=8 expandtab ft=python:

if __name__ == '__main__':
    main()
