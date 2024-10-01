class Helpers:
    @staticmethod
    def is_valid_user(parameter):
        # e.g. some logic for user authorization with using JWT
        return parameter < 3
        # test http://localhost:5000/test?parameter=4  
    @staticmethod
    def is_parameter_exist_in_db(parameter):
        # e.g. some logic for getting order from storage and check if it belongs to user
        return parameter > 0

    @staticmethod
    def some_function(parameter):
        # e.g. some advanced business logic for order’s finalization as some transaction in db
        if parameter == 1:
            'raise critical error' > 1

        return parameter
 
# is_valid_userなどの変数も自定義
# parameter == 1の時に、'raise critical error' > 1をチェックし、でも　> はnot supported between instances of 'str' and 'int'Traceback
# なのでエラーが発生し、エラーファイルのハンドラが動作する