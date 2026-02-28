<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        /* Override to match the screenshot precisely and sync with medicine-dashboard */
        .profile-container {
            margin-left: 290px !important; /* Standardized 280px sidebar + 10px gap */
            margin-top: 115px !important; /* Clear sticky header */
            padding: 25px 30px !important;
            background-color: transparent !important; /* Remove individual background to fix "color separation" */
            min-height: calc(100vh - 115px) !important;
            width: calc(100% - 290px) !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: flex-start !important;
        }

        /* Essential: Ensure body background is consistent throughout the right side */
        body {
            background-color: #f8fafc !important; 
        }

        .profile-card {
            background: white !important;
            border-radius: 16px !important; 
            padding: 30px 40px !important; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.06) !important;
            border: none !important; /* Remove blue border line and any other border */
            max-width: none !important; 
            width: 100% !important;
            position: relative !important;
            margin-bottom: 30px !important;
        }

        .profile-title-top {
            font-size: 24px !important; 
            font-weight: 700 !important;
            color: #1e293b !important;
            margin-bottom: 25px !important;
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
        }

        .profile-title-top i {
            color: #3b82f6 !important; 
        }

        .profile-form {
            display: flex !important;
            flex-direction: column !important;
            gap: 24px !important; 
        }

        .form-row {
            display: grid !important;
            grid-template-columns: 1fr 1fr !important;
            gap: 30px !important;
        }

        .form-field {
            display: flex !important;
            flex-direction: column !important;
            gap: 8px !important;
        }

        .form-field label {
            font-size: 0.9rem !important; 
            font-weight: 600 !important;
            color: #475569 !important;
            margin-bottom: 0 !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }

        .form-field label img {
            width: 18px !important;
            height: 18px !important;
        }

        .form-field input,
        .form-field select {
            width: 100% !important;
            padding: 12px 16px !important; 
            border: 1px solid #e2e8f0 !important; 
            border-radius: 10px !important;
            font-size: 0.95rem !important;
            color: #1e293b !important;
            background-color: #f8fafc !important; 
            transition: all 0.2s ease !important;
        }

        .form-field input:focus,
        .form-field select:focus {
            outline: none !important;
            border-color: #3b82f6 !important;
            background-color: #ffffff !important;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1) !important;
        }

        .form-field input:disabled {
            background-color: #f1f5f9 !important;
            color: #94a3b8 !important;
            cursor: not-allowed !important;
        }

        .button-group {
            display: flex !important;
            justify-content: flex-start !important;
            gap: 16px !important;
            margin-top: 15px !important;
            padding-top: 25px !important;
            border-top: 1px solid #f1f5f9 !important;
        }

        .btn {
            padding: 10px 24px !important;
            border: none !important;
            border-radius: 12px !important; 
            font-size: 15px !important;
            font-weight: 600 !important;
            cursor: pointer !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
            transition: all 0.2s ease !important;
            color: white !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #2563eb) !important;
        }

        .btn-warning {
            background: #f59e0b !important;
        }

        .btn-secondary {
            background: #64748b !important;
        }

        .btn:hover {
            transform: translateY(-1px) !important;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1) !important;
            opacity: 0.95 !important;
        }

        .btn img {
            width: 18px !important;
            height: 18px !important;
            filter: brightness(0) invert(1) !important;
        }

        .alert {
            padding: 14px 20px !important;
            border-radius: 12px !important;
            margin-bottom: 25px !important;
            font-weight: 500 !important;
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
            font-size: 15px !important;
        }

        .alert-success {
            background-color: #f0fdf4 !important;
            color: #16a34a !important;
            border: 1px solid #bbf7d0 !important;
        }

        .alert-error {
            background-color: #fef2f2 !important;
            color: #dc2626 !important;
            border: 1px solid #fecaca !important;
        }

        @media (max-width: 1024px) {
            .profile-container {
                margin-left: 290px !important;
            }
            .form-row {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/view/common/header.jsp" %>
    
    <div style="display: flex;">
        <%@ include file="/view/common/sidebar.jsp" %>
        
        <div class="profile-container">
            <h1 class="profile-title-top">
                <i class="fas fa-user-circle"></i>
                Thông tin cá nhân
            </h1>
            <div class="profile-card">
                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${successMessage}</span>
                </div>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${errorMessage}</span>
                </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/profile" method="post" class="profile-form">
                    <!-- Row 1: Full Name & Phone -->
                    <div class="form-row">
                        <div class="form-field">
                            <label>
                                <img src="${pageContext.request.contextPath}/assets/img/fname.png" alt="Name">
                                Họ và tên của bạn
                            </label>
                            <input type="text" name="fullName" value="${user.fullName}" placeholder="Họ và tên của bạn" required>
                        </div>
                        
                        <div class="form-field">
                            <label>
                                <img src="${pageContext.request.contextPath}/assets/img/phonea.png" alt="Phone">
                                Số điện thoại
                            </label>
                            <input type="tel" name="phone" value="${user.phone}" placeholder="Số điện thoại của bạn">
                        </div>
                    </div>

                    <!-- Row 2: Gender & Date of Birth -->
                    <div class="form-row">
                        <div class="form-field">
                            <label>
                                <img src="${pageContext.request.contextPath}/assets/img/gender.png" alt="Gender">
                                Giới tính
                            </label>
                            <select name="gender">
                                <option value="" disabled ${empty user.gender ? 'selected' : ''}>Giới tính của bạn</option>
                                <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                        
                        <div class="form-field">
                            <label>
                                <img src="${pageContext.request.contextPath}/assets/img/dob.png" alt="DOB">
                                Ngày sinh
                            </label>
                            <input type="date" name="dob" value="<fmt:formatDate value='${user.dob}' pattern='yyyy-MM-dd' />" placeholder="Ngày sinh của bạn">
                        </div>
                    </div>

                    <!-- Row 3: Email -->
                    <div class="form-field form-field-full">
                        <label>
                            <img src="${pageContext.request.contextPath}/assets/img/email.png" alt="Email">
                            Email
                        </label>
                        <input type="email" name="email" value="${user.email}" placeholder="Email của bạn" disabled>
                    </div>

                    <!-- Row 4: Address -->
                    <div class="form-field form-field-full">
                        <label>
                            <img src="${pageContext.request.contextPath}/assets/img/address.png" alt="Address">
                            Địa chỉ
                        </label>
                        <input type="text" name="address" value="${user.address}" placeholder="Địa chỉ của bạn">
                    </div>

                    <!-- Buttons -->
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <img src="${pageContext.request.contextPath}/assets/img/save.png" alt="Save">
                            Lưu
                        </button>
                        
                        <button type="button" class="btn btn-warning" onclick="window.location.href='${pageContext.request.contextPath}/forgot-password'">
                            <img src="${pageContext.request.contextPath}/assets/img/forgot.png" alt="Forgot Password">
                            Quên mật khẩu
                        </button>
                        
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/change-password'">
                            <img src="${pageContext.request.contextPath}/assets/img/pass.png" alt="Change Password">
                            Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
