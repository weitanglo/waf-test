import os
from flask import request
from api import app
from api.resources.errors import UnauthorizedError, BadRequestError, NotFoundResourceError
from api.resources.helpers import Helpers
from flask import send_from_directory

# a template of almost anty API point looks at any classical programming framework.
# change  /test whatever you want
@app.route('/test', methods=['GET'])
def test():     
    parameter = request.args.get('parameter', type=int)
  
    # input validation and sanitizing. using a type conversion to int and check if parameter is present or not
    if parameter is None:
        raise BadRequestError('Bad input parameters')
    # test http://localhost:5000/test?eoiwo=weiufh 
    # different custom exptions related to input validation. built in existing expections if it indeed is used to your purpose  
    # the main point here is that you need to have one abstract custom exception type for that exact type of errors and bad inputs that will 
    # allow you to group all input validation errors in one bucket. very essential from a security aspect 

    # auth validation -> e.g credentials and permissions for operation are correct
    if not Helpers.is_valid_user(parameter):
        raise UnauthorizedError('Incorrect Credentials')  
    # public API points return non sensitive data is no need to use, but important an complicated

    # user <-> input identification, e.g order ID indeed belongs to current user
    if not Helpers.is_parameter_exist_in_db(parameter):
        raise NotFoundResourceError('Parameter does not exist at DB or does not belong to user')
    # when the input parameter is some order id ,and we have to verify if  this order belongs a logged in user using some db
    # the most essential things is that you need to have a separate expcetion group for that purpose 

    # some service that performs business logic, e.g finalize order
    Helpers.some_function(parameter)
    # In real life, some critical exeption caused by constraint violation at database level

    return "OK" if parameter else 0, 200


@app.route("/ping", methods=['GET'])
def ping():
    return "OK", 200 
# used at AWS deployment as health check

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(
        os.path.join(app.root_path, 'static'),
        'favicon.ico', mimetype='image/vnd.microsoft.icon'
    )
# not spam application logs with missing icon when we will send requests to API using browser