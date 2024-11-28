FROM python:3.9-alpine3.17
LABEL maintainer="bunlongly.com"

ENV PYTHONUNBUFFERED=1

# Copy the requirements file and application code
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Create virtual environment and install dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \ 
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Set the virtual environment as the PATH for the container
ENV PATH="/py/bin:$PATH"

# Set non-root user to run the app
USER django-user

# Command to run your app (e.g., Django app)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
