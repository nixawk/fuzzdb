#!/usr/bin/env python
# -*- coding: utf-8 -*-

from urlparse import urlparse
import sys


def parse_domain(url):
    """parse domain from url"""
    scheme, netloc, path, params, query, fragment = urlparse(url)
    return netloc.split(':')[0]


def main():
    """main fnction"""
    if len(sys.argv) == 2:

        domains = []

        f_domains = open('domains.txt', 'a')
        f_urls = open(sys.argv[1], 'r')

        while True:
            url = f_urls.readline().strip()

            if url:
                domain = parse_domain(url)
                domain_parts = domain.split(".")

                if domain and (domain not in domains) and len(domain_parts) == 3:
                    print(domain)
                    domains.append(domain)
                    f_domains.write('%s\n' % domain_parts[0])
            else:
                break
        f_domains.close()
        f_urls.close()
    else:
        print "python %s urls.txt" % sys.argv[0]


if __name__ == '__main__':
    main()
