FROM python:3.5-buster

COPY ./start.sh /usr/local/bin/start.sh
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apt update && apt upgrade -y && apt install -y git build-essential libffi-dev python3-dev && \
    pip install virtualenv bcrypt cffi && \
    virtualenv -p /usr/bin/python3 venv && mkdir /app && \
    chmod +x /usr/local/bin/*.sh

WORKDIR /app
ENV GIT=https://github.com/marfebr/blog.git 
VOLUME ["/app", "/venv"]

EXPOSE 5000

CMD [ "/usr/local/bin/start.sh" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

#RUN pip install -r requirements.txt

#CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
