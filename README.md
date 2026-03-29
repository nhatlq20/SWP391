# PharmacyLife - Pharmacy Management Website

**PharmacyLife** is a specialized e-commerce platform for the pharmaceutical industry, designed to solve complex inventory challenges (multi-unit conversions), optimize the shopping experience.

---

## 🛠️ Tech Stack

| Component | Technology |
| :--- | :--- |
| **Backend** | Java 11, Jakarta EE 10 (Servlet, JSP, JSTL) |
| **Database** | Microsoft SQL Server |
| **Build Tool** | Maven 3.x |
| **AI Integration** | Google GenAI SDK (Gemini API) |
| **Security/Mail** | Jakarta Mail (OTP), Dotenv (Environment Variables) |
| **Frontend** | Vanilla HTML, CSS, JavaScript |

---

## ⚙️ Installation & Setup

### 1. Prerequisites
- JDK 11 or higher.
- Microsoft SQL Server.
- Apache Tomcat 10+ (or any server supporting Jakarta EE 10).

### 2. Database Configuration
- Execute the SQL scripts in the `/sql` directory (if available) to initialize tables and sample data.
- Update the connection string in your `.env` file or DAO configuration.

### 3. Environment Variables (`.env`)
Create a `.env` file in the project root with the following details:
```env
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=PharmacyLife;encrypt=true;trustServerCertificate=true;
DB_USER=your_username
DB_PASSWORD=your_password
EMAIL_USERNAME=your_email@gmail.com
EMAIL_PASSWORD=your_app_password
GEMINI_API_KEY=your_gemini_api_key
```

### 4. Build and Run
Use Maven to build the project:
```bash
mvn clean package
```
Then deploy the `.war` file to Tomcat or run directly using the Cargo plugin:
```bash
mvn cargo:run
```
