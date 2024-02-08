# Partimos de la imagen php en su versión 7.4
FROM php:7.4-fpm

# Nos movemos a /var/www/
WORKDIR /app

# Instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    locales \
    zip \
    unzip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    git \
    curl

# Instalamos extensiones de PHP
RUN docker-php-ext-install pdo_mysql zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Instalamos composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiamos todos los archivos de la carpeta del proyecto (los archivos de laravel) a /app/
COPY . .

# Instalamos dependendencias de composer
RUN composer install --no-ansi --no-dev --no-interaction --no-progress --optimize-autoloader --no-scripts

# Agregando clave de aplicación
# RUN php artisan key:generate

# Iniciando servidor de laravel
CMD php artisan key:generate && \
    php artisan migrate && \
    php artisan serve --host=0.0.0.0 --port=5000

# Exponemos el puerto 5000 a la network
EXPOSE 5000

# Corremos el comando php-fpm para ejecutar PHP
# CMD [""php-fpm""]
