FROM bitwalker/alpine-elixir:1.9 as build

COPY . .

RUN rm -Rf _build && \
  mix deps.get && \
  mix release

ENTRYPOINT iex -S mix