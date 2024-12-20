default: test build

run: venv
	. venv/bin/activate && python manage.py runserver

test: venv
	. venv/bin/activate && coverage run manage.py test && coverage html

build: Dockerfile
	docker build . -t mysite

venv: requirements.txt
	python3.8 -m venv venv
	. venv/bin/activate && pip install --upgrade pip && pip install pip-tools
	. venv/bin/activate && pip install -r requirements.txt

venv-upgrade: venv
	. venv/bin/activate && pip-compile --upgrade requirements.ini
	$(MAKE) venv

deploy: docker-compose.yaml
	docker compose up -d

stop: docker-compose.yaml
	docker compose down

clean:
	rm -rf htmlcov/ .coverage

clean-all: clean
	rm -rf venv/
