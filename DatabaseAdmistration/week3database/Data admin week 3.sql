CREATE DATABASE IF NOT EXISTS banking_system;
USE banking_system;
 
-- ============================================================
--  TABLE: Customers
-- ============================================================
CREATE TABLE Customers (
    customer_id     INT             PRIMARY KEY AUTO_INCREMENT,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    date_of_birth   DATE            NOT NULL,
    gender          CHAR(1)         CHECK (gender IN ('M','F','O')),
    email           VARCHAR(100)    UNIQUE NOT NULL,
    phone           VARCHAR(20)     NOT NULL,
    address         VARCHAR(200)    NOT NULL,
    city            VARCHAR(50)     NOT NULL,
    state           VARCHAR(50)     NOT NULL,
    zip_code        VARCHAR(10)     NOT NULL,
    country         VARCHAR(50)     NOT NULL DEFAULT 'USA',
    ssn_last4       CHAR(4)         NOT NULL,          -- last 4 digits only
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);
 
-- ============================================================
--  TABLE: Accounts
-- ============================================================
CREATE TABLE Accounts (
    account_id      INT             PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT             NOT NULL,
    account_number  VARCHAR(20)     UNIQUE NOT NULL,
    account_type    VARCHAR(20)     NOT NULL CHECK (account_type IN ('Checking','Savings','Money Market','CD')),
    balance         DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    currency        CHAR(3)         NOT NULL DEFAULT 'USD',
    interest_rate   DECIMAL(5,4)    NOT NULL DEFAULT 0.0000,   -- e.g. 0.0450 = 4.50%
    opened_date     DATE            NOT NULL,
    closed_date     DATE            NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Active' CHECK (status IN ('Active','Closed','Frozen','Dormant')),
    CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
 
-- ============================================================
--  TABLE: Transactions
-- ============================================================
CREATE TABLE Transactions (
    transaction_id      INT             PRIMARY KEY AUTO_INCREMENT,
    account_id          INT             NOT NULL,
    transaction_type    VARCHAR(20)     NOT NULL CHECK (transaction_type IN ('Deposit','Withdrawal','Transfer','Payment','Fee','Interest')),
    amount              DECIMAL(15,2)   NOT NULL CHECK (amount > 0),
    direction           CHAR(1)         NOT NULL CHECK (direction IN ('C','D')),  -- Credit / Debit
    balance_after       DECIMAL(15,2)   NOT NULL,
    description         VARCHAR(255)    NOT NULL,
    reference_number    VARCHAR(30)     UNIQUE NOT NULL,
    channel             VARCHAR(20)     NOT NULL CHECK (channel IN ('ATM','Online','Branch','Mobile','Wire')),
    transaction_date    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status              VARCHAR(20)     NOT NULL DEFAULT 'Completed' CHECK (status IN ('Pending','Completed','Failed','Reversed')),
    related_account_id  INT             NULL,   -- populated for Transfers
    CONSTRAINT fk_transactions_account FOREIGN KEY (account_id)         REFERENCES Accounts(account_id),
    CONSTRAINT fk_transactions_related FOREIGN KEY (related_account_id) REFERENCES Accounts(account_id)
);
 
-- ============================================================
--  TABLE: Loans
-- ============================================================
CREATE TABLE Loans (
    loan_id             INT             PRIMARY KEY AUTO_INCREMENT,
    customer_id         INT             NOT NULL,
    account_id          INT             NOT NULL,   -- linked disbursement / repayment account
    loan_type           VARCHAR(30)     NOT NULL CHECK (loan_type IN ('Personal','Mortgage','Auto','Student','Business','Home Equity')),
    principal_amount    DECIMAL(15,2)   NOT NULL CHECK (principal_amount > 0),
    outstanding_balance DECIMAL(15,2)   NOT NULL,
    interest_rate       DECIMAL(5,4)    NOT NULL,   -- annual rate e.g. 0.0699
    term_months         INT             NOT NULL CHECK (term_months > 0),
    monthly_payment     DECIMAL(15,2)   NOT NULL,
    start_date          DATE            NOT NULL,
    end_date            DATE            NOT NULL,
    next_payment_date   DATE            NOT NULL,
    total_paid          DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    status              VARCHAR(20)     NOT NULL DEFAULT 'Active' CHECK (status IN ('Active','Paid Off','Defaulted','Deferred','Closed')),
    collateral          VARCHAR(200)    NULL,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_loans_account  FOREIGN KEY (account_id)  REFERENCES Accounts(account_id)
);
 
 -- ============================================================
--  TABLE: Staff
-- ============================================================
CREATE TABLE Staff (
    staff_id    INT          PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20)  UNIQUE NOT NULL,
    full_name   VARCHAR(100) NOT NULL,
    role        VARCHAR(80)  NOT NULL,
    department  VARCHAR(80)  NOT NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_staff_department ON Staff(department);
 
-- ============================================================
--  INDEXES  (performance)
-- ============================================================
CREATE INDEX idx_accounts_customer    ON Accounts(customer_id);
CREATE INDEX idx_transactions_account ON Transactions(account_id);
CREATE INDEX idx_transactions_date    ON Transactions(transaction_date);
CREATE INDEX idx_loans_customer       ON Loans(customer_id);
CREATE INDEX idx_loans_status         ON Loans(status);
 
-- ============================================================
--  SAMPLE DATA — Customers  (20 records)
-- ============================================================
INSERT INTO Customers
    (first_name, last_name, date_of_birth, gender, email, phone, address, city, state, zip_code, country, ssn_last4)
VALUES
    ('James',     'Anderson',  '1985-03-14', 'M', 'james.anderson@email.com',   '555-201-1001', '12 Oak Street',        'New York',     'NY', '10001', 'USA', '4821'),
    ('Maria',     'Garcia',    '1990-07-22', 'F', 'maria.garcia@email.com',     '555-201-1002', '45 Pine Avenue',       'Los Angeles',  'CA', '90001', 'USA', '3367'),
    ('Robert',    'Williams',  '1978-11-05', 'M', 'robert.williams@email.com',  '555-201-1003', '78 Maple Drive',       'Chicago',      'IL', '60601', 'USA', '9143'),
    ('Linda',     'Martinez',  '1995-01-30', 'F', 'linda.martinez@email.com',   '555-201-1004', '23 Elm Court',         'Houston',      'TX', '77001', 'USA', '5512'),
    ('Michael',   'Johnson',   '1982-09-18', 'M', 'michael.johnson@email.com',  '555-201-1005', '99 Cedar Lane',        'Phoenix',      'AZ', '85001', 'USA', '7784'),
    ('Patricia',  'Lee',       '1973-04-11', 'F', 'patricia.lee@email.com',     '555-201-1006', '310 Birch Boulevard',  'Philadelphia', 'PA', '19101', 'USA', '2298'),
    ('David',     'Brown',     '1988-06-25', 'M', 'david.brown@email.com',      '555-201-1007', '55 Willow Way',        'San Antonio',  'TX', '78201', 'USA', '6631'),
    ('Jennifer',  'Davis',     '1993-12-07', 'F', 'jennifer.davis@email.com',   '555-201-1008', '18 Spruce Circle',     'San Diego',    'CA', '92101', 'USA', '8847'),
    ('Richard',   'Wilson',    '1969-08-02', 'M', 'richard.wilson@email.com',   '555-201-1009', '401 Ash Road',         'Dallas',       'TX', '75201', 'USA', '1123'),
    ('Susan',     'Taylor',    '1991-02-19', 'F', 'susan.taylor@email.com',     '555-201-1010', '76 Chestnut Place',    'San Jose',     'CA', '95101', 'USA', '4459'),
    ('Charles',   'Moore',     '1980-10-31', 'M', 'charles.moore@email.com',    '555-201-1011', '232 Poplar Street',    'Austin',       'TX', '73301', 'USA', '3376'),
    ('Barbara',   'Jackson',   '1976-05-16', 'F', 'barbara.jackson@email.com',  '555-201-1012', '88 Walnut Avenue',     'Jacksonville', 'FL', '32099', 'USA', '9904'),
    ('Thomas',    'Harris',    '1987-03-28', 'M', 'thomas.harris@email.com',    '555-201-1013', '14 Magnolia Drive',    'Columbus',     'OH', '43085', 'USA', '7712'),
    ('Jessica',   'Thompson',  '1998-09-09', 'F', 'jessica.thompson@email.com', '555-201-1014', '502 Dogwood Lane',     'Fort Worth',   'TX', '76101', 'USA', '5538'),
    ('Kevin',     'White',     '1983-07-14', 'M', 'kevin.white@email.com',      '555-201-1015', '61 Sycamore Court',    'Charlotte',    'NC', '28201', 'USA', '2267'),
    ('Sarah',     'Robinson',  '1996-11-23', 'F', 'sarah.robinson@email.com',   '555-201-1016', '39 Redwood Terrace',   'Indianapolis', 'IN', '46201', 'USA', '8891'),
    ('Mark',      'Clark',     '1971-01-08', 'M', 'mark.clark@email.com',       '555-201-1017', '127 Hickory Street',   'San Francisco','CA', '94102', 'USA', '1145'),
    ('Nancy',     'Lewis',     '1989-04-17', 'F', 'nancy.lewis@email.com',      '555-201-1018', '85 Pecan Drive',       'Seattle',      'WA', '98101', 'USA', '6623'),
    ('Paul',      'Walker',    '1975-06-30', 'M', 'paul.walker@email.com',      '555-201-1019', '200 Juniper Road',     'Denver',       'CO', '80201', 'USA', '3390'),
    ('Karen',     'Hall',      '1994-08-05', 'F', 'karen.hall@email.com',       '555-201-1020', '47 Cypress Boulevard',  'Nashville',    'TN', '37201', 'USA', '7756');
 
-- ============================================================
--  SAMPLE DATA — Accounts  (25 records)
-- ============================================================
INSERT INTO Accounts
    (customer_id, account_number, account_type, balance, currency, interest_rate, opened_date, status)
VALUES
    ( 1, 'ACC-10000001', 'Checking',     15200.00, 'USD', 0.0000, '2018-04-10', 'Active'),
    ( 1, 'ACC-10000002', 'Savings',      42500.75, 'USD', 0.0450, '2018-04-10', 'Active'),
    ( 2, 'ACC-10000003', 'Checking',      8750.30, 'USD', 0.0000, '2019-06-15', 'Active'),
    ( 2, 'ACC-10000004', 'Money Market', 120000.00,'USD', 0.0520, '2020-01-20', 'Active'),
    ( 3, 'ACC-10000005', 'Checking',      3200.00, 'USD', 0.0000, '2015-09-01', 'Active'),
    ( 3, 'ACC-10000006', 'Savings',       9800.50, 'USD', 0.0400, '2015-09-01', 'Active'),
    ( 4, 'ACC-10000007', 'Checking',      6100.25, 'USD', 0.0000, '2021-03-22', 'Active'),
    ( 5, 'ACC-10000008', 'Checking',     22400.80, 'USD', 0.0000, '2017-11-14', 'Active'),
    ( 5, 'ACC-10000009', 'CD',           50000.00, 'USD', 0.0550, '2023-01-05', 'Active'),
    ( 6, 'ACC-10000010', 'Savings',      17300.60, 'USD', 0.0430, '2016-07-19', 'Active'),
    ( 7, 'ACC-10000011', 'Checking',      4500.00, 'USD', 0.0000, '2020-05-30', 'Active'),
    ( 7, 'ACC-10000012', 'Savings',      11200.40, 'USD', 0.0400, '2020-05-30', 'Active'),
    ( 8, 'ACC-10000013', 'Checking',      9900.15, 'USD', 0.0000, '2022-08-08', 'Active'),
    ( 9, 'ACC-10000014', 'Checking',      2500.00, 'USD', 0.0000, '2010-02-28', 'Active'),
    ( 9, 'ACC-10000015', 'Money Market',  75000.00,'USD', 0.0510, '2013-06-10', 'Active'),
    (10, 'ACC-10000016', 'Savings',       33800.90, 'USD', 0.0450, '2019-09-25', 'Active'),
    (11, 'ACC-10000017', 'Checking',      7600.00, 'USD', 0.0000, '2018-12-01', 'Active'),
    (12, 'ACC-10000018', 'Checking',       500.00, 'USD', 0.0000, '2014-03-17', 'Dormant'),
    (13, 'ACC-10000019', 'Savings',      28400.00, 'USD', 0.0420, '2020-10-11', 'Active'),
    (14, 'ACC-10000020', 'Checking',     11100.55, 'USD', 0.0000, '2023-04-02', 'Active'),
    (15, 'ACC-10000021', 'CD',           25000.00, 'USD', 0.0530, '2022-11-15', 'Active'),
    (16, 'ACC-10000022', 'Savings',      14700.30, 'USD', 0.0440, '2021-07-07', 'Active'),
    (17, 'ACC-10000023', 'Checking',     31500.00, 'USD', 0.0000, '2009-08-20', 'Active'),
    (18, 'ACC-10000024', 'Savings',       6200.80, 'USD', 0.0400, '2022-02-14', 'Active'),
    (19, 'ACC-10000025', 'Checking',     18900.00, 'USD', 0.0000, '2016-05-05', 'Active');
 
-- ============================================================
--  SAMPLE DATA — Transactions  (25 records)
-- ============================================================
INSERT INTO Transactions
    (account_id, transaction_type, amount, direction, balance_after, description, reference_number, channel, transaction_date, status, related_account_id)
VALUES
    ( 1, 'Deposit',    3000.00, 'C', 15200.00, 'Payroll direct deposit – ACME Corp',       'TXN-20240901-001', 'Online',  '2024-09-01 08:00:00', 'Completed', NULL),
    ( 1, 'Withdrawal', 500.00,  'D', 14700.00, 'ATM withdrawal – Broadway & 42nd',          'TXN-20240903-002', 'ATM',     '2024-09-03 14:22:00', 'Completed', NULL),
    ( 1, 'Transfer',   1000.00, 'D', 13700.00, 'Transfer to Savings ACC-10000002',           'TXN-20240905-003', 'Mobile',  '2024-09-05 10:15:00', 'Completed',  2),
    ( 2, 'Transfer',   1000.00, 'C', 43500.75, 'Transfer from Checking ACC-10000001',        'TXN-20240905-004', 'Mobile',  '2024-09-05 10:15:01', 'Completed',  1),
    ( 2, 'Interest',    159.38, 'C', 43660.13, 'Monthly interest credit – Sep 2024',         'TXN-20240930-005', 'Branch',  '2024-09-30 00:01:00', 'Completed', NULL),
    ( 3, 'Deposit',   2500.00,  'C',  8750.30, 'Check deposit – freelance payment',          'TXN-20241001-006', 'Branch',  '2024-10-01 09:45:00', 'Completed', NULL),
    ( 3, 'Payment',    320.00,  'D',  8430.30, 'Utility bill – Pacific Gas & Electric',      'TXN-20241005-007', 'Online',  '2024-10-05 18:00:00', 'Completed', NULL),
    ( 4, 'Interest',    520.00, 'C',120520.00, 'Monthly interest credit – Oct 2024',         'TXN-20241031-008', 'Online',  '2024-10-31 00:01:00', 'Completed', NULL),
    ( 5, 'Deposit',   1500.00,  'C',  3200.00, 'Cash deposit – branch teller',               'TXN-20241102-009', 'Branch',  '2024-11-02 11:30:00', 'Completed', NULL),
    ( 5, 'Fee',          12.00, 'D',  3188.00, 'Monthly maintenance fee',                    'TXN-20241130-010', 'Online',  '2024-11-30 00:01:00', 'Completed', NULL),
    ( 6, 'Deposit',   5000.00,  'C',  9800.50, 'Transfer from external bank',                'TXN-20241115-011', 'Wire',    '2024-11-15 13:00:00', 'Completed', NULL),
    ( 7, 'Payment',    850.00,  'D',  6100.25, 'Credit card payment – Chase Sapphire',       'TXN-20241201-012', 'Online',  '2024-12-01 09:00:00', 'Completed', NULL),
    ( 8, 'Deposit',   4000.00,  'C', 22400.80, 'Payroll – Tech Solutions Inc.',              'TXN-20241201-013', 'Online',  '2024-12-01 08:00:00', 'Completed', NULL),
    ( 8, 'Withdrawal', 200.00,  'D', 22200.80, 'ATM withdrawal – Airport Terminal 2',        'TXN-20241210-014', 'ATM',     '2024-12-10 07:45:00', 'Completed', NULL),
    ( 9, 'Interest',   229.17,  'C', 50229.17, 'Monthly interest credit – Dec 2024',         'TXN-20241231-015', 'Online',  '2024-12-31 00:01:00', 'Completed', NULL),
    (10, 'Deposit',   2000.00,  'C', 17300.60, 'Savings top-up from external account',       'TXN-20241205-016', 'Wire',    '2024-12-05 14:20:00', 'Completed', NULL),
    (11, 'Deposit',   1800.00,  'C',  4500.00, 'Payroll direct deposit',                     'TXN-20241215-017', 'Online',  '2024-12-15 08:00:00', 'Completed', NULL),
    (11, 'Transfer',  1000.00,  'D',  3500.00, 'Transfer to Savings ACC-10000012',           'TXN-20241220-018', 'Mobile',  '2024-12-20 17:00:00', 'Completed', 12),
    (12, 'Transfer',  1000.00,  'C', 12200.40, 'Transfer from Checking ACC-10000011',        'TXN-20241220-019', 'Mobile',  '2024-12-20 17:00:01', 'Completed', 11),
    (13, 'Deposit',   3500.00,  'C',  9900.15, 'Payroll – Creative Agency LLC',              'TXN-20250101-020', 'Online',  '2025-01-01 08:00:00', 'Completed', NULL),
    (14, 'Withdrawal', 300.00,  'D',  2200.00, 'ATM withdrawal – downtown branch',           'TXN-20250110-021', 'ATM',     '2025-01-10 12:00:00', 'Completed', NULL),
    (15, 'Interest',   318.75,  'C', 75318.75, 'Quarterly interest credit – Q4 2024',        'TXN-20241231-022', 'Online',  '2024-12-31 00:02:00', 'Completed', NULL),
    (16, 'Deposit',   5000.00,  'C', 33800.90, 'Inheritance deposit – wire transfer',        'TXN-20250115-023', 'Wire',    '2025-01-15 10:00:00', 'Completed', NULL),
    (19, 'Payment',   1200.00,  'D', 18900.00, 'Mortgage loan payment – Jan 2025',           'TXN-20250115-024', 'Online',  '2025-01-15 09:00:00', 'Completed', NULL),
    (23, 'Deposit',   8000.00,  'C', 31500.00, 'Consulting fee – wire transfer',             'TXN-20250120-025', 'Wire',    '2025-01-20 11:30:00', 'Completed', NULL);
 
-- ============================================================
--  SAMPLE DATA — Loans  (20 records)
-- ============================================================
INSERT INTO Loans
    (customer_id, account_id, loan_type, principal_amount, outstanding_balance, interest_rate,
     term_months, monthly_payment, start_date, end_date, next_payment_date, total_paid, status, collateral)
VALUES
    ( 1,  1, 'Mortgage',     320000.00, 298450.00, 0.0695,  360, 2131.25, '2020-05-01', '2050-05-01', '2025-02-01',  21550.00, 'Active',   '12 Oak Street, New York NY 10001'),
    ( 1,  1, 'Auto',          28000.00,  19200.00, 0.0599,   60,  541.25, '2021-08-01', '2026-08-01', '2025-02-01',   8800.00, 'Active',   '2021 Toyota Camry VIN-4T1BF1FK5MU123456'),
    ( 2,  3, 'Personal',      15000.00,   8750.00, 0.0899,   36,  476.97, '2022-06-01', '2025-06-01', '2025-02-01',   6250.00, 'Active',   NULL),
    ( 3,  5, 'Mortgage',     250000.00, 235100.00, 0.0725,  360, 1706.64, '2015-09-01', '2045-09-01', '2025-02-01',  14900.00, 'Active',   '78 Maple Drive, Chicago IL 60601'),
    ( 4,  7, 'Student',       45000.00,  39800.00, 0.0450,  120,  466.08, '2021-09-01', '2031-09-01', '2025-02-01',   5200.00, 'Active',   NULL),
    ( 5,  8, 'Business',     100000.00,  72000.00, 0.0750,   84, 1572.48, '2019-03-01', '2026-03-01', '2025-02-01',  28000.00, 'Active',   'Business equipment & receivables'),
    ( 5,  8, 'Auto',          35000.00,  31500.00, 0.0619,   72,  597.08, '2023-01-01', '2029-01-01', '2025-02-01',   3500.00, 'Active',   '2023 Ford F-150 VIN-1FTFW1E50PFA12345'),
    ( 6, 10, 'Home Equity',   60000.00,  54200.00, 0.0680,  120,  690.16, '2021-07-01', '2031-07-01', '2025-02-01',   5800.00, 'Active',   '310 Birch Blvd, Philadelphia PA 19101'),
    ( 7, 11, 'Personal',      10000.00,   4100.00, 0.1099,   24,  467.16, '2023-03-01', '2025-03-01', '2025-02-01',   5900.00, 'Active',   NULL),
    ( 8,  8, 'Mortgage',     415000.00, 401200.00, 0.0710,  360, 2792.64, '2023-07-01', '2053-07-01', '2025-02-01',  13800.00, 'Active',   '55 Willow Way, San Antonio TX 78201'),
    ( 9, 14, 'Personal',      20000.00,      0.00, 0.0849,   36,  631.64, '2021-01-01', '2024-01-01', '2024-01-01',  20000.00, 'Paid Off', NULL),
    (10, 16, 'Auto',          22000.00,  14400.00, 0.0579,   60,  424.56, '2021-06-01', '2026-06-01', '2025-02-01',   7600.00, 'Active',   '2021 Honda Accord VIN-1HGCV1F34MA012345'),
    (11, 17, 'Student',       30000.00,  27600.00, 0.0500,  120,  318.18, '2022-09-01', '2032-09-01', '2025-02-01',   2400.00, 'Active',   NULL),
    (12, 18, 'Personal',       5000.00,   5000.00, 0.1199,   24,  235.37, '2024-06-01', '2026-06-01', '2025-02-01',      0.00, 'Defaulted',NULL),
    (13, 19, 'Mortgage',     380000.00, 375200.00, 0.0730,  360, 2607.54, '2023-11-01', '2053-11-01', '2025-02-01',   4800.00, 'Active',   '14 Magnolia Drive, Columbus OH 43085'),
    (14, 20, 'Auto',          19000.00,  16700.00, 0.0649,   48,  451.39, '2023-05-01', '2027-05-01', '2025-02-01',   2300.00, 'Active',   '2023 Nissan Sentra VIN-3N1AB8CV5PL234567'),
    (15, 21, 'Business',      75000.00,  60800.00, 0.0780,   60, 1521.42, '2022-12-01', '2027-12-01', '2025-02-01',  14200.00, 'Active',   'Business inventory & equipment'),
    (16, 22, 'Personal',       8000.00,   2800.00, 0.0999,   24,  369.49, '2023-02-01', '2025-02-01', '2025-02-01',   5200.00, 'Active',   NULL),
    (17, 23, 'Home Equity',   90000.00,  88100.00, 0.0660,  180,  790.50, '2024-09-01', '2039-09-01', '2025-02-01',   1900.00, 'Active',   '127 Hickory Street, San Francisco CA 94102'),
    (19, 25, 'Mortgage',     540000.00, 529600.00, 0.0675,  360, 3500.60, '2024-06-01', '2054-06-01', '2025-02-01',  10400.00, 'Active',   '200 Juniper Road, Denver CO 80201');
 
-- ============================================================
--  END OF SCRIPT
-- ============================================================


use banking_system;
show tables;
select * from staff;
create user 'michael'@'localhost' identified by 'michael123$';
grant all privileges on banking_system.* to 'michael'@'localhost' with grant option;
flush privileges;
create user 'jessica'@'localhost' identified by 'jessica2023$';
GRANT ALTER, CREATE VIEW, DELETE, SELECT, INSERT, UPDATE 
ON banking_system.* TO 'jessica'@'localhost';
flush privileges;
create user 'james'@'localhost' identified by 'james2024$';
grant ALTER, CREATE VIEW, DELETE, SELECT, INSERT, UPDATE on bankin_system.* to 'james'@'localhost';
flush privileges;
create user 'david'@'localhost' identified by 'david123456$';
grant ALTER, CREATE VIEW, INSERT, SELECT, UPDATE on banking_system.* to 'david'@'localhost';
flush privileges;
create user 'matthew'@'localhost' identified by 'matthew6789$';
grant CREATE VIEW, SELECT, INSERT, UPDATE on banking_system. * to 'matthew'@'localhost';
flush privileges;
create user 'emily'@'localhost' identified by 'emily1234$';
grant SELECT, INSERT, UPDATE on banking_system.customers to 'emily'@'localhost';
grant SELECT, INSERT, UPDATE on banking_system.accounts to 'emily'@'localhost';
grant SELECT, INSERT, UPDATE on banking_system.transactions to 'emily'@'localhost';
flush privileges;
create user 'jonh'@'localhost' identified by 'john1234$';
grant SELECT, INSERT, UPDATE on banking_system.customers to 'jonh'@'localhost';
grant SELECT, INSERT, UPDATE on banking_system.accounts to 'jonh'@'localhost';
grant SELECT, INSERT, UPDATE on banking_system.transactions to 'jonh'@'localhost';
flush privileges;
create user 'mario'@'localhost' identified by 'mario1234$' password expire interval 100 day;
grant SELECT, INSERT, UPDATE on banking_system.customers to 'mario'@'localhost';
grant SELECT, INSERT, UPDATE on banking_system.accounts to 'mario'@'localhost';
grant SELECT, INSERT, UPDATE on banking_system.transactions to 'mario'@'localhost';
flush privileges;

REVOKE INSERT, UPDATE ON banking_system.Customers FROM 'emily'@'localhost';
flush privileges;
show grants for 'emily'@'localhost';
