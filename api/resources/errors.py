from api import app
import os
import traceback
from flask import jsonify, request
from api.resources.logger import create_logger

logger = create_logger() 

# class後の関数は自定義、（）内はハンドラに転送
class AppError(Exception):
    """All custom Application Exceptions"""
    pass

class UnauthorizedError(AppError):
    """Custom Authentication Error Class."""
    code = 403
    description = "Authentication Error"


class BadRequestError(AppError):
    """Custom Bad Request Error Class."""
    code = 400
    description = "Bad Request Error"


class NotFoundResourceError(AppError):
    """Custom NotFoundResourceError Error Class."""
    code = 404
    description = "NotFoundResourceError Error"

# For custom errors, response only has minimum information about exception
# Never dispose detail information about error to customers in response, but using log for ourselves
# In case of application errors, we also register request URL
@app.errorhandler(AppError)
def handle_error(err):
    response = {"error": err.description, "code": err.code, "message": ""}
    if len(err.args) > 0:
        response["message"] = err.args[0]
    logger.error(f"{err.description}. Status code: {err.code}. Url: {request.url}")
    return jsonify(response), err.code

# Critial Exception
# The whole trace error stack is added here, exposing stack error trace at response, but only in development mode
# development mode is setting on Dockerfile 
@app.errorhandler(Exception)
def handle_exception(e):
    error_message = str(e)
    error_message += traceback.format_exc() if \
        os.getenv('FLASK_ENV') == 'development' \
        else ''
    logger.error(f"Critical Error. Status code: 500. Error message: {error_message}. Url: {request.url}")
    return jsonify(
        error=error_message,
        status=500
    ), 500
