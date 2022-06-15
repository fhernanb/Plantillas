images_version=3.1.0

all:
	docker build \
		 --build-arg images_version=$(images_version) \
         --build-arg source_image=flow123d/install-intel:$(images_version) \
         --tag flow123d/geomop-base-intel:$(images_version) \
         .

	docker push flow123d/geomop-base-intel:$(images_version)
