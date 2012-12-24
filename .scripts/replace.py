#!/usr/bin/env python
"""
Simple key-value replacer in files

Keys to be replaced are written in the following format - '<key>'
inside template files.

The key-to-replacement mappings are set inside file formatted according
to ini file syntax rules and the filename is passed on command line
with '--ini' parameter. Format of the ini file is the following:

    [replacements]
    <key_1> = replacement_1
    <key_2> = replacement_2
    ...
    <key_n> = replacement_n

Assuming you have your replacement strings configured inside 'replace.ini',
and your tempate is 'config.tpl', and output file is 'config.final', then
command will look like this:

    python conf_replace.py --ini replace.ini --tpl config.tpl --out config.final

"""
import ConfigParser
import argparse
import os


def get_arg_parser():
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--ini', action='store',
                            required=True, dest='ini',
                            help='.ini file with replacement strings')
    arg_parser.add_argument('--tpl', action='store',
                            required=True, dest='tpl',
                            help='input file where the strings will be replaced')
    arg_parser.add_argument('--out', action='store',
                            required=True, dest='out',
                            help='the result after replacements')
    return arg_parser


def parse_and_validate_args(arg_parser):
    cmd_args = arg_parser.parse_args()
    is_readable(cmd_args.ini)
    is_readable(cmd_args.tpl)
    return cmd_args


def is_readable(file_path):
    if not os.access(file_path, os.F_OK):
        raise IOError("'%s' is not found" % file_path)
    if not os.access(file_path, os.R_OK):
        raise IOError("'%s' is not readable" % file_path)


def main():
    cmd_args = parse_and_validate_args(get_arg_parser())

    config_parser = ConfigParser.SafeConfigParser()
    config_parser.read(cmd_args.ini)
    replacements = config_parser.items('replacements')

    tpl_file = open(cmd_args.tpl, 'r')
    output_file = open(cmd_args.out, 'w')

    for line in tpl_file:
        for key, value in replacements:
            key = '<' + key + '>'
            if line.find(key) > 0:
                line = line.replace(key, value)
                break

        output_file.write(line)

    tpl_file.close()
    output_file.close()


if __name__ == '__main__':
    try:
        main()
    except Exception, e:
        print "ERROR: %s" % str(e)
