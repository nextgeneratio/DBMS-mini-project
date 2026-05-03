# Privilege Management System

This folder contains SQL procedures for managing MySQL user privileges dynamically across five roles: **Admin**, **Dean**, **Lecturer**, **Technical Officer**, and **Student**.

## Files Overview

### 1. `sp_manage_role_privileges.sql`
Core procedures for assigning and revoking privileges:
- `sp_exec_sql()` — Helper procedure to execute dynamic SQL statements safely
- `sp_assign_role()` — Assign a role to an existing MySQL user
- `sp_revoke_role()` — Revoke a role from a user

**Roles supported:**
- **admin**: ALL PRIVILEGES WITH GRANT OPTION on the database
- **dean**: ALL PRIVILEGES on the database
- **lecturer**: ALL PRIVILEGES on the database
- **technical_officer**: SELECT, INSERT, UPDATE on Attendance table
- **student**: SELECT on Final_Marks and Attendance tables

### 2. `sp_create_user_with_role.sql`
Combined procedure to streamline user creation:
- `sp_create_user_with_role()` — Create a new user and assign a role in a single call

**Why use this?**
- Single procedure call instead of two steps
- Automatically checks if user exists (avoids errors)
- Simplifies bulk user provisioning

### 3. `grant_privileges.sql`
Reference SQL statements showing static GRANT commands for each role. Use this as a fallback if you prefer manual user creation and privilege assignment.

### 4. `usage_examples.sql`
Comprehensive examples demonstrating how to:
- Create users and assign roles (recommended approach)
- Verify user privileges
- Revoke roles
- Test user login
- Manage user accounts

## Quick Start

### Prerequisites
- MySQL server running with `StudentManagement` database
- Root or admin account with GRANT privileges
- All procedure files loaded

### Loading Procedures

Run these commands in order:

```bash
mysql -u root -p StudentManagement < "Privilege/sp_manage_role_privileges.sql"
mysql -u root -p StudentManagement < "Privilege/sp_create_user_with_role.sql"
```

### Creating Users and Assigning Roles

**Option 1: Recommended (one-step)**

```sql
-- Create admin user
CALL sp_create_user_with_role('admin','admin1','localhost','admin_password_123','StudentManagement');

-- Create lecturer user
CALL sp_create_user_with_role('lecturer','lect1','localhost','lect1_password','StudentManagement');

-- Create student user (read-only access)
CALL sp_create_user_with_role('student','s2021001','localhost','student_password','StudentManagement');
```

**Option 2: Manual (two-step)**

```sql
-- Step 1: Create user
CREATE USER 'lect2'@'localhost' IDENTIFIED BY 'lect2_password';

-- Step 2: Assign role
CALL sp_assign_role('lecturer','lect2','localhost','StudentManagement');
```

### Verifying Privileges

```sql
-- Check user grants
SHOW GRANTS FOR 'lect1'@'localhost';
SHOW GRANTS FOR 's2021001'@'localhost';

-- List all database users
SELECT user, host FROM mysql.user WHERE host='localhost' AND user NOT IN ('root','mysql.sys','mysql.session');
```

### Revoking Privileges

```sql
-- Remove lecturer role
CALL sp_revoke_role('lecturer','lect1','localhost','StudentManagement');

-- Drop user entirely
DROP USER 'lect1'@'localhost';
```

### Testing User Login

```bash
# Test login as lecturer
mysql -u lect1 -p StudentManagement

# Test login as student
mysql -u s2021001 -p StudentManagement
```

## Role Privilege Matrix

| Role | Database Privileges | Table Privileges | Grant Option |
|------|-------------------|-------------------|--------------|
| Admin | ALL on DB.* | (covered by DB) | YES |
| Dean | ALL on DB.* | (covered by DB) | NO |
| Lecturer | ALL on DB.* | (covered by DB) | NO |
| Technical Officer | Limited | SELECT, INSERT, UPDATE on Attendance | NO |
| Student | Limited | SELECT on Final_Marks, Attendance | NO |

## Security Notes

1. **Passwords**: Always use strong passwords. Never commit passwords to version control.
2. **Input Sanitization**: Procedures escape single quotes in usernames and passwords. Ensure passwords do not use complex special characters.
3. **GRANT OPTION**: Only Admin role has GRANT OPTION; this prevents escalation of privileges.
4. **Password Changes**: 
   ```sql
   ALTER USER 'username'@'localhost' IDENTIFIED BY 'new_password';
   ```
5. **User Deletion**:
   ```sql
   DROP USER 'username'@'localhost';
   ```

## Troubleshooting

### Error: "You are not allowed to create a user with GRANT"
- **Cause**: User account doesn't exist yet or previous GRANT failed
- **Solution**: Ensure user exists first or use `sp_create_user_with_role()` to auto-create

### Error: "Unknown procedure 'sp_assign_role'"
- **Cause**: Procedures not loaded
- **Solution**: Load `sp_manage_role_privileges.sql` first

### Can't login with created user
- **Cause**: Wrong password or user not created
- **Solution**: Verify user exists: `SELECT * FROM mysql.user WHERE user='username';`

## Example: Complete Setup

```sql
-- Load procedures (run as root)
mysql -u root -p StudentManagement < "Privilege/sp_manage_role_privileges.sql"
mysql -u root -p StudentManagement < "Privilege/sp_create_user_with_role.sql"

-- Create all users
CALL sp_create_user_with_role('admin','admin1','localhost','admin@123','StudentManagement');
CALL sp_create_user_with_role('dean','dean1','localhost','dean@123','StudentManagement');
CALL sp_create_user_with_role('lecturer','lect1','localhost','lect@123','StudentManagement');
CALL sp_create_user_with_role('lecturer','lect2','localhost','lect@123','StudentManagement');
CALL sp_create_user_with_role('technical_officer','to1','localhost','to@123','StudentManagement');
CALL sp_create_user_with_role('student','s2021001','localhost','student@123','StudentManagement');
CALL sp_create_user_with_role('student','s2021002','localhost','student@123','StudentManagement');

-- Verify
SHOW GRANTS FOR 'lect1'@'localhost';
SHOW GRANTS FOR 's2021001'@'localhost';
```

## Integration with Project Workflows

These privilege procedures support the DBMS project requirements:

- **Lecturers** can modify attendance, grades, and marks (full database access)
- **Technical Officers** can record and update attendance data only
- **Students** can view their final marks and attendance (read-only)
- **Admin & Dean** manage the entire system with appropriate controls

---

For more information, see `usage_examples.sql`.
