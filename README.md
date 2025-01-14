# OSP-APP

OSP-APP is an application designed to assist volunteer fire departments (Ochotnicza Straż Pożarna) with their operations. This README provides essential instructions for configuring and setting up the application, including database migration and configuration.

## Introduction

OSP-APP is designed to manage training sessions and events unrelated to unit deployments for incidents. The app provides tools for efficiently handling operations and personnel. It utilizes Python, Flask, and SQLAlchemy for backend development and database management, while Flutter is used for developing a responsive and user-friendly frontend interface.
## Installation

To get started with OSP-APP, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/osp-app.git
   cd osp-app
   ```

2. Create a virtual environment and activate it:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
   ```

3. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Database Configuration and Migration

To set up the database and perform migrations, follow these steps:

1. Configure the Database URI:

Edit the `config.py` file and update the `SQLALCHEMY_DATABASE_URI` to match your database configuration.

Example configuration:
```python
# config.py

SQLALCHEMY_DATABASE_URI = 'postgresql://username:password@localhost/dbname'
```


```

2. Initialize and Perform Migrations:

# make sure you delete folder migartions  before initialize new database
Run the following commands to initialize and migrate the database:
```bash
flask db init          # Initializes a migrations directory
flask db migrate       # Generates migration scripts
flask db upgrade       # Applies the migrations to the database
```

## Running the Application

To start the application, use the following command:
```bash
flask run
```

The application will be available at `http://127.0.0.1:5000` by default.

## Contributing

We welcome contributions to OSP-APP. Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your commit message here"
   ```
4. Push the branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a Pull Request on the main repository.

## License

OSP-APP is licensed under the [MIT License](LICENSE).

For further assistance, feel free to contact us or open an issue in the repository.
