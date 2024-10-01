import logging
import os
from flask_log_request_id import RequestIDLogFilter

# Use monit, and extending log info about concrete time log level, request ID, filename and exact line where error has happended and
# only the message that was created at handler is added
# RequestId is sent by request processor like AWS ALB, improve tracing and debugging 
def create_logger():
    log_format = 'MONIT %(asctime)s.%(msecs)03d [%(levelname)s] [%(request_id)s] [%(filename)s:%(lineno)d] %(message)s'
    logger = logging.getLogger()
    while logger.hasHandlers():
        logger.removeHandler(logger.handlers[0])

    logger.setLevel(logging.INFO)
    formatter = logging.Formatter(fmt=log_format, datefmt='%Y-%m-%dT%H:%M:%S')
    stream_handler = logging.StreamHandler() #To forword all logs to the putput of the container 
    stream_handler.setFormatter(formatter)
    stream_handler.addFilter(RequestIDLogFilter())
    logger.addHandler(stream_handler)

    #login option to the file. Just example
    logs_dir = './logs'
    logs_path = 'logs.txt'

    if not os.path.exists(logs_dir):
        os.makedirs(logs_dir)

    chf = logging.FileHandler(os.path.join(logs_dir, logs_path))
    chf.setFormatter(formatter)
    chf.addFilter(RequestIDLogFilter())
    logger.addHandler(chf)

    return logger
