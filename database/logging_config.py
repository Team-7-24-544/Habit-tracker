import logging
from logging.handlers import RotatingFileHandler


def setup_logging():
    error_logger = logging.getLogger("error_logger")
    error_logger.setLevel(logging.ERROR)
    error_handler = RotatingFileHandler(
        'data/errors.log',
        maxBytes=1024 * 1024 * 5,
        backupCount=5
    )
    error_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s [%(filename)s:%(lineno)d]'
    ))
    error_logger.addHandler(error_handler)

    info_logger = logging.getLogger("info_logger")
    info_logger.setLevel(logging.INFO)
    info_handler = RotatingFileHandler(
        'data/app.log',
        maxBytes=1024 * 1024 * 5,
        backupCount=5
    )
    info_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s'
    ))
    info_logger.addHandler(info_handler)
