#! /usr/bin/python

import logging
from logging.handlers import SysLogHandler

if __name__ == "__main__":
    sh = SysLogHandler(address='/dev/log')
    sh.setFormatter(logging.Formatter('test: %(levelname)s: %(message)s'))
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.DEBUG)
    root_logger.addHandler(sh)
    logging.info("test")

