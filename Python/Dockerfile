FROM python:3.5-alpine

COPY ./app.py /usr/src/app/app.py
COPY ./requirements.txt /usr/src/app/requirements.txt

EXPOSE 5000

WORKDIR /usr/src/app

RUN pip install -r requirements.txt

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]