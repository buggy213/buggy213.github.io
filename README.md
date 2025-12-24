I use Docker to encapsulate ruby/jekyll. 

## Building the container
```bash
docker build -t jekyll-container .
```

## Running the containers
```bash
docker run --rm -p 4000:4000 -p 35729:35729 -v "$(pwd):/site" jekyll-container
```
