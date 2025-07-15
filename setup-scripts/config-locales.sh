#!/bin/bash

sudo sed -i -e 's/#\s*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	sudo locale-gen && \
	echo -e 'LANG=en_US.UTF-8\nLC_COLLATE=C' | sudo tee /etc/locale.conf
