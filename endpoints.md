# Grand Hotel Bekaveka API

Backend API для мобильного приложения на FastAPI + PostgreSQL.

**Base URL:** `http://91.147.104.165:5555/api/v1`

**Swagger UI:** http://91.147.104.165:5555/docs

---

## 🔐 Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Регистрация нового пользователя |
| POST | `/auth/verify-otp` | Подтверждение email (после регистрации) |
| POST | `/auth/login` | Вход в систему |
| POST | `/auth/resend-otp` | Повторная отправка OTP |
| POST | `/auth/forgot-password` | Запрос сброса пароля |
| POST | `/auth/reset-password` | Сброс пароля с OTP |
| POST | `/auth/refresh` | Обновление токенов |
| GET | `/auth/me` | Получить профиль (требует токен) |

---

## 📱 API Reference

### 1. Register

```
POST /api/v1/auth/register
```

**Request:**
```json
{
  "username": "john_doe",
  "email": "john@gmail.com",
  "password": "MyPassword123"
}
```

**Response (200):**
```json
{
  "message": "Registration successful. Please check your email for OTP.",
  "user_id": 1,
  "email": "john@gmail.com",
  "otp_sent": true
}
```

**Errors:**
- `400` — Email already registered / Username already taken

---

### 2. Verify OTP

Подтверждение email после регистрации.

```
POST /api/v1/auth/verify-otp
```

**Request:**
```json
{
  "email": "john@gmail.com",
  "otp_code": "1234"
}
```

**Response (200):**
```json
{
  "message": "Account verified successfully",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Errors:**
- `400` — Invalid or expired OTP code
- `404` — User not found

---

### 3. Login

```
POST /api/v1/auth/login
```

**Request:**
```json
{
  "email": "john@gmail.com",
  "password": "MyPassword123"
}
```

**Response (200):**
```json
{
  "message": "Login successful",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Errors:**
- `401` — Invalid email or password
- `403` — Please verify your email first

---

### 4. Resend OTP

```
POST /api/v1/auth/resend-otp
```

**Request:**
```json
{
  "email": "john@gmail.com",
  "purpose": "registration"
}
```

**Purpose values:** `registration`, `password_reset`

**Response (200):**
```json
{
  "message": "OTP code sent to your email",
  "otp_sent": true,
  "expires_in_seconds": 300
}
```

---

### 5. Forgot Password

```
POST /api/v1/auth/forgot-password
```

**Request:**
```json
{
  "email": "john@gmail.com"
}
```

**Response (200):**
```json
{
  "message": "OTP sent to your email",
  "otp_sent": true,
  "expires_in_seconds": 300
}
```

**Errors:**
- `404` — User not found

---

### 6. Reset Password

```
POST /api/v1/auth/reset-password
```

**Request:**
```json
{
  "email": "john@gmail.com",
  "otp_code": "1234",
  "new_password": "NewPassword456"
}
```

**Response (200):**
```json
{
  "message": "Password reset successfully"
}
```

**Errors:**
- `400` — Invalid or expired OTP code
- `404` — User not found

---

### 7. Refresh Token

```
POST /api/v1/auth/refresh
```

**Request:**
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Errors:**
- `401` — Invalid token

---

### 8. Get Current User

**Требует авторизацию!**

```
GET /api/v1/auth/me
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@gmail.com",
  "is_active": true,
  "is_verified": true,
  "created_at": "2025-12-17T12:30:00.000000"
}
```

**Errors:**
- `401` — Could not validate credentials

---

## 🔄 User Flows

### Registration Flow
```
1. POST /register        →  OTP приходит на email
2. POST /verify-otp      →  Получаешь access + refresh токены
3. Сохраняешь токены
```

### Login Flow
```
1. POST /login           →  Сразу получаешь токены
2. Сохраняешь токены
```

### Forgot Password Flow
```
1. POST /forgot-password →  OTP приходит на email
2. POST /reset-password  →  Пароль сброшен
3. POST /login           →  Входишь с новым паролем
```

### Token Refresh Flow
```
Когда access_token истёк (401 ошибка):
1. POST /refresh с refresh_token
2. Получаешь новые токены
3. Сохраняешь и повторяешь запрос
```

---

## 📋 Headers

### Для всех запросов
```
Content-Type: application/json
Accept: application/json
```

### Для защищённых запросов
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer <access_token>
```

---

## ⏱️ Token Lifetime

| Token | Время жизни |
|-------|-------------|
| `access_token` | 30 минут |
| `refresh_token` | 7 дней |
| `OTP code` | 5 минут |

---

## ❌ Error Response Format

```json
{
  "detail": "Error message here"
}
```

---

## 🚀 Development

### Запуск через Docker

```bash
cd grand-hotel-bekaveka
docker-compose up -d
```

### Проверить логи

```bash
docker-compose logs -f api
```

### Остановить

```bash
docker-compose down
```
