# ローカルでアプリを実装する
FROM ubuntu:20.04

ENV FLASK_ENV=development \
    PYTHONPATH=/app/ \
    AWS_DEFAULT_REGION=ap-northeast-1
# 環境をエクスポートする
RUN apt-get update && \
    apt-get -y install python3-pip && \
    apt-get -y install nano
# システムの更新
ENV APP_HOME=/app
RUN mkdir $APP_HOME

COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
# 必要なミドルウェアやテストソフトをインストールする
COPY api/ $APP_HOME/api
COPY main.py $APP_HOME/main.py
COPY run.sh $APP_HOME/run.sh
COPY tests/ $APP_HOME/tests
COPY pytest.ini $APP_HOME/pytest.ini
COPY .flake8 $APP_HOME/.flake8

RUN mkdir -p $APP_HOME/logs && cd $APP_HOME/logs && touch logs.txt

RUN addgroup --system app && adduser --system --group app
RUN chown -R app:app $APP_HOME
WORKDIR $APP_HOME
USER app
# ユーザー作成し、そのユーザーでアプリを操作する
CMD ["sh", "run.sh"]