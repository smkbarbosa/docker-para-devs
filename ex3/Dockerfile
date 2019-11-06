FROM python:3.8-alpine

COPY ./app.py /usr/src/app/app.py
COPY ./requirements.txt /usr/src/app/requirements.txt
COPY ./gunicorn.sh /usr/local/bin/gunicorn.sh
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 5000

WORKDIR /usr/src/app

VOLUME [ "/usr/src/app" ]

RUN pip install -r requirements.txt && \
chmod +x /usr/local/bin/*.sh

CMD [ "/usr/local/bin/gunicorn.sh" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
