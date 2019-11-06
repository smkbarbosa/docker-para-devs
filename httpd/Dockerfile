FROM httpd:2.2
LABEL Samuel Barbosa <samuel.barbosa@uft.edu.br>

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

COPY ./httpd-foreground /usr/local/bin/httpd-foreground
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/*.sh

VOLUME [ "/usr/local/apache2/htdocs" ]

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]