FROM nvcr.io/nvidia/pytorch:23.04-py3


#dodaj brisanje ovog smeca u /workspaceu
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends
RUN pip install pytorch-ignite torchvision jupyter jupyterlab
#remove if you dont like zsh shell