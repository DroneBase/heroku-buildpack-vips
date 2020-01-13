FROM heroku/heroku:18

ARG VIPS_VERSION=$VIPS_VERSION

RUN echo ${VIPS_VERSION}

ENV DEBIAN_FRONTEND noninteractive

# useful build tools ... we need gtk-doc to build orc, since they don't ship
# pre-baked tarballs
RUN apt-get update && apt-get install -y \
	build-essential \
	autoconf \
	automake \
	libtool \
	intltool \
	gtk-doc-tools \
	unzip \
	wget \
	git \
	pkg-config

# heroku:18 includes some libraries, like tiff and jpeg, as part of the
# run-time platform, and we want to use those libs if we can
#
# see https://devcenter.heroku.com/articles/stack-packages
#
# libgsf needs libxml2
RUN apt-get update && apt-get install -y \
	glib-2.0-dev \
	libexpat-dev \
	librsvg2-dev \
	libpng-dev \
	libjpeg-dev \
	libtiff5-dev \
	libexif-dev \
	liblcms2-dev \
	libxml2-dev \
	libfftw3-dev \
  libpoppler-glib-dev \
  libgsf-1-dev


ARG WEBP_VERSION=1.0.2
ARG WEBP_URL=https://storage.googleapis.com/downloads.webmproject.org/releases/webp

RUN cd /usr/src \
	&& wget ${WEBP_URL}/libwebp-$WEBP_VERSION.tar.gz \
	&& tar xf libwebp-${WEBP_VERSION}.tar.gz \
	&& cd libwebp-${WEBP_VERSION} \
	&& ./configure --prefix=/usr/src/vips \
	&& make \
	&& make install

ARG GIFLIB_VERSION=5.1.4
ARG GIFLIB_URL=http://downloads.sourceforge.net/project/giflib

RUN cd /usr/src \
	&& wget ${GIFLIB_URL}/giflib-$GIFLIB_VERSION.tar.bz2 \
	&& tar xf giflib-${GIFLIB_VERSION}.tar.bz2 \
	&& cd giflib-${GIFLIB_VERSION} \
	&& ./configure --prefix=/usr/src/vips \
	&& make \
	&& make install

# orc uses ninja and meson to build
RUN apt-get install -y \
    python3-pip
RUN pip3 install ninja meson

ARG ORC_VERSION=0.4.31
ARG ORC_URL=https://dronebase-public.s3-us-west-2.amazonaws.com/buildpacks

RUN cd /usr/src \
	&& wget ${ORC_URL}/orc-$ORC_VERSION.tar.gz \
	&& tar xf orc-${ORC_VERSION}.tar.gz \
	&& cd orc-${ORC_VERSION} \
	&& meson build --prefix=/usr/src/vips --libdir=/usr/src/vips/lib \
	&& cd build \
	&& ninja \
	&& ninja install

ARG GSF_VERSION=1.14.46
ARG GSF_URL=http://ftp.gnome.org/pub/GNOME/sources/libgsf

RUN cd /usr/src \
	&& wget ${GSF_URL}/${GSF_VERSION%.*}/libgsf-$GSF_VERSION.tar.xz \
	&& tar xf libgsf-${GSF_VERSION}.tar.xz \
	&& cd libgsf-${GSF_VERSION} \
	&& ./configure --prefix=/usr/src/vips --disable-gtk-doc \
	&& make \
	&& make install


ARG CFIT_URL=http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.47.tar.gz

RUN cd /usr/src \
	&& wget ${CFIT_URL} \
	&& tar xf cfitsio-3.47.tar.gz \
	&& cd cfitsio-3.47 \
	&& ./configure --prefix=/usr/src/vips --disable-gtk-doc \
	&& make \
	&& make install

ARG LCMS_URL=http://downloads.sourceforge.net/project/lcms/lcms/2.9/lcms2-2.9.tar.gz

RUN cd /usr/src \
	&& wget ${LCMS_URL} \
	&& tar xf lcms2-2.9.tar.gz \
	&& cd lcms2-2.9 \
	&& ./configure --prefix=/usr/src/vips --disable-gtk-doc \
	&& make \
	&& make install

ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN cd /usr/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& export PKG_CONFIG_PATH=/usr/src/vips/lib/pkgconfig \
	&& ./configure --prefix=/usr/src/vips --disable-gtk-doc \
	&& make \
	&& make install

# clean the build area ready for packaging
RUN cd /usr/src/vips \
	&& rm bin/gif* bin/orc* bin/gsf* bin/batch_* bin/vips-* \
	&& rm bin/vipsprofile bin/light_correct bin/shrink_width \
	&& strip lib/*.a lib/lib*.so* \
	&& rm -rf share/gtk-doc \
	&& rm -rf share/man \
	&& rm -rf share/thumbnailers

RUN cd /usr/src/vips \
  && rm -rf build \
  && mkdir build \
  && tar czf \
    /usr/src/vips/build/libvips.tar.gz bin include lib
