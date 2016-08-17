# How to install django and create a project & Apps

### Make sure Python > 3.4 is installed (for using pip)
### Include following two direction in PATH environment variable

	C:\Python34\Scripts
	C:\Python34

### Install django on local

	pip install django

#### Create Django Project & Apps

##### Create Django Project

Once Django is installed, create a Django project from command line. 

	django-admin startproject {projectname}

This creates a directory structure and files for {projectname}.

![](http://i.imgur.com/0SYHrw7.jpg)

##### Host the project created on local server

	python manage.py runserver

Please note that manage.py is in the top-level project directory

##### Create an App inside the project

	python manage.py startapp main_app

This creates its own directory and generated files as below. Compare with above. 

![](http://i.imgur.com/f2u4x1i.jpg)
