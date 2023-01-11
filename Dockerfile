FROM fukamachi/qlot:latest

WORKDIR /app
COPY . /app

RUN qlot install

ENV PATH $PATH:/app/.qlot/bin

ENTRYPOINT ["qlot", "exec", "clackup", "-s", "chat", "--address", "0.0.0.0", "--port", "3000", "./src/app.lisp"]
