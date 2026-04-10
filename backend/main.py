import subprocess
import os
import tempfile
import gzip
import shutil
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse

app = FastAPI()

# Full path to mysqldump on Windows
MYSQLDUMP_PATH = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"

# Database credentials
DB_NAME = "student"
DB_USER = "root"
DB_PASSWORD = "1234"  # Replace with your actual password
DB_HOST = "localhost"
DB_PORT = "3306"

@app.get("/")
async def root():
    return {"message": "Database Backup Server is Running"}

@app.get("/download-student-backup")
async def backup_student_db():
    # Check if mysqldump exists
    if not os.path.exists(MYSQLDUMP_PATH):
        raise HTTPException(
            status_code=500,
            detail=f"mysqldump not found at {MYSQLDUMP_PATH}"
        )

    try:
        # Create a temporary file for raw SQL
        with tempfile.NamedTemporaryFile(delete=False, suffix=".sql") as tmp_sql_file:
            raw_sql_path = tmp_sql_file.name

        # Run mysqldump
        command = [
            MYSQLDUMP_PATH,
            "-h", DB_HOST,
            "-P", DB_PORT,
            "-u", DB_USER,
            f"-p{DB_PASSWORD}",
            DB_NAME
        ]
        subprocess.run(command, check=True, stdout=open(raw_sql_path, "w"), text=True)

        # Compress the SQL file into .gz
        backup_path = raw_sql_path + ".gz"
        with open(raw_sql_path, "rb") as f_in:
            with gzip.open(backup_path, "wb") as f_out:
                shutil.copyfileobj(f_in, f_out)

        # Remove raw SQL file
        os.remove(raw_sql_path)

        # Return the compressed backup
        if os.path.exists(backup_path):
            return FileResponse(
                path=backup_path,
                filename="student_backup.sql.gz",
                media_type="application/gzip"
            )
        else:
            raise HTTPException(status_code=500, detail="Backup file was not created.")

    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"MySQL backup failed: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))