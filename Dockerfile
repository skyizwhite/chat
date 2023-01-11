FROM fukamachi/qlot:latest

WORKDIR /app
COPY . /app

RUN apt-get update
RUN qlot install

ENV PATH $PATH:/app/.qlot/bin

EXPOSE 3000

ENTRYPOINT ["qlot", "exec", "clackup", "-s", "chat", "--address", "0.0.0.0", "--port", "3000", "./src/app.lisp"]
