FROM docker.io/pytorch/pytorch:2.5.1-cuda12.1-cudnn9-runtime

WORKDIR /code

RUN apt-get update && \
    apt-get install -y git && \
    apt install -y default-jre

RUN git clone https://github.com/mumbert/dcase2024-task6-baseline-project.git && \
    cd dcase2024-task6-baseline-project

WORKDIR /code/dcase2024-task6-baseline-project

RUN pip install --force-reinstall pip==23.0 && \
    pip install -e . && \
    exit 0
RUN pip install matplotlib==3.10.1 seaborn==0.13.2 spacy==3.8.4  && \
    python -m spacy download en_core_web_sm && \
    exit 0
RUN pip install gradio==5.21.0 && \
    exit 0
# RUN python src/dcase24t6/test_installation.py
# RUN huggingface-hub==0.27.1

# RUN wget https://zenodo.org/records/10849427/files/epoch_192-step_001544-mode_min-val_loss_3.3758.ckpt?download=1 && \
#     wget https://zenodo.org/records/10849427/files/tokenizer.json?download=1    

#     pip install -e . --use-deprecated=legacy-resolver && \
#     pip install -e .[dev] --use-deprecated=legacy-resolver \
# COPY /home/mumbert/.cache/huggingface/stored_tokens /root/.cache/huggingface/stored_tokens
# RUN dcase24t6-prepare

# Set up a new user named "user" with user ID 1000
# RUN useradd -m -u 1000 user

# Switch to the "user" user
#USER user

# Set home to the user's home directory
#ENV HOME=/home/user \
#    PATH=/home/user/.local/bin:$PATH

# Set the working directory to the user's home directory
#WORKDIR $HOME/app

# RUN pip install gradio

# Copy the current directory contents into the container at $HOME/app setting the owner to the user
#COPY --chown=user . $HOME/app
WORKDIR /code/dcase2024-task6-baseline-project
COPY . .

ENV MPLCONFIGDIR=/var/cache/matplotlib
ENV TRANSFORMERS_CACHE=/var/cache/huggingface/hub
ENV NUMBA_CACHE_DIR=/tmp/NUMBA_CACHE_DIR/
RUN mkdir -p /var/cache/matplotlib && chmod -R 777 /var/cache/matplotlib && \
    mkdir -p /var/cache/huggingface/hub && chmod -R 777 /var/cache/huggingface/ && chmod -R 777 /var/cache/huggingface/hub && \
    mkdir /.config && chmod -R 777 /.config && \
    mkdir /nltk_data && chmod -R 777 /nltk_data && \
    mkdir -p /tmp/NUMBA_CACHE_DIR && chmod -R 777 /tmp/NUMBA_CACHE_DIR

RUN python -c 'import torch; from dcase24t6.nn.hub import baseline_pipeline; model = baseline_pipeline()'

ENV GRADIO_SERVER_PORT=7860
ENV GRADIO_SERVER_NAME="0.0.0.0"
EXPOSE 7860

CMD ["python", "app.py"]