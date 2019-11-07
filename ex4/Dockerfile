FROM python:3.5-buster

RUN apt update && apt upgrade -y && apt install -y git

COPY ./start.sh /usr/local/bin/start.sh
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/*.sh

EXPOSE 5000

WORKDIR /usr/src/app

CMD [ "/usr/local/bin/start.sh" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

#RUN pip install -r requirements.txt

#CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
