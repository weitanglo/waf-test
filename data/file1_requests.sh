curl https://flask.loweitang.com/test?parameter=0
curl https://flask.loweitang.com/test?parameter=1
curl https://flask.loweitang.com/test?parameter=2
curl https://flask.loweitang.com/test?parameter=3
curl https://flask.loweitang.com/test?parameter=4
curl https://flask.loweitang.com/test?parameter=5
#classical hackers attempts to find configuration files
curl https://flask.loweitang.com/.env
curl https://flask.loweitang.com/env/.env
curl https://flask.loweitang.com/.environment
curl https://flask.loweitang.com/.env.%7B%7BDN%7D%7D
curl https://flask.loweitang.com/.aws/credentials
curl https://flask.loweitang.com?page=../../../../../../../../../../etc/passwd
curl https://flask.loweitang.com/download?working_dir=%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2Fetc%2F&type&file=passwd
curl https://flask.loweitang.com//install/index.php.bak
#XSS and SQL injection attempts
curl https://flask.loweitang.com/test?parameter=a=%3Cscript%3Ealert%28%22XSS%22%29%3B%3C%2Fscript%3E&b=UNION+SELECT+ALL+FROM+information_schema+AND+%27+or+SLEEP%285%29+or+%27&c=..%2F..%2F..%2F..%2Fetc%2Fpasswd
curl https://flask.loweitang.com?page_on=20&page_nr=1&sort=off&sort_order=asc%27%29+AND+1%3D1+UNION+ALL+SELECT+1%2CNULL%2C%27%3Cscript%3Ealert%28%22XSS%22%29%3C%2Fscript%3E%27%2Ctable_name+FROM+information_schema.tables+WHERE+2%3E1--%2F%2A%2A%2F%3B+EXEC+xp_cmdshell%28%27cat+..%2F..%2F..%2Fetc%2Fpasswd%27%29%23
