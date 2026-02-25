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
        /* Override to match the screenshot precisely */
        .profile-container {
            margin-left: 280px !important;
            margin-top: 110px !important; /* Adjusted to match previous requests */
            padding: 40px 50px !important; /* More top padding for title gap */
            background-color: #f1f5f9 !important; /* Slightly more greyish background */
            min-height: calc(100vh - 110px) !important;
            width: calc(100% - 280px) !important;
            display: flex !important;
            flex-direction: column !important; /* Title on top of card */
            align-items: flex-start !important; /* Align to the LEFT */
        }

        .profile-card {
            background: white !important;
            border-radius: 20px !important; /* More rounded */
            padding: 35px 50px !important; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.05) !important;
            border: 2px solid #4B9AFF !important; 
            max-width: 90% !important; /* Allow it to be wider but controlled */
            width: 100% !important;
            position: relative !important;
            margin-bottom: 50px !important; /* Reduced bottom empty space */
        }

        .profile-title-top {
            font-size: 28px !important;
            font-weight: 700 !important;
            color: #1e293b !important;
            margin-bottom: 25px !important;
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
        }

        .profile-title-top i {
            color: #4B9AFF !important;
        }

        .profile-form {
            display: flex !important;
            flex-direction: column !important;
            gap: 20px !important; 
        }

        .form-row {
            display: grid !important;
            grid-template-columns: 1fr 1fr !important;
            gap: 30px !important; /* Reduced gap between columns */
        }

        .form-field {
            display: flex !important;
            flex-direction: column !important;
            gap: 6px !important; /* Reduced gap between label and input */
        }

        .form-field label {
            font-size: 14px !important; /* Slightly smaller labels */
            font-weight: 500 !important;
            color: #1e293b !important;
            margin-bottom: 0 !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }

        .form-field label img {
            width: 16px !important; /* Smaller icons */
            height: 16px !important;
        }

        .form-field input,
        .form-field select {
            width: 100% !important;
            padding: 10px 16px !important; /* More compact input padding */
            border: none !important;
            border-radius: 10px !important;
            font-size: 13px !important;
            color: #475569 !important;
            background-color: #f3f6f9 !important; /* Light grey background from screenshot */
            transition: all 0.2s ease !important;
        }

        .form-field input:focus,
        .form-field select:focus {
            outline: none !important;
            background-color: #ffffff !important;
            box-shadow: 0 0 0 2px rgba(75, 154, 255, 0.2) !important;
        }

        .button-group {
            display: flex !important;
            justify-content: flex-start !important;
            gap: 15px !important;
            margin-top: 10px !important; /* Reduced top margin */
            padding-top: 0 !important;
            border-top: none !important;
        }

        .btn {
            padding: 8px 30px !important; /* More compact buttons */
            border: none !important;
            border-radius: 30px !important; /* Pill shape */
            font-size: 14px !important;
            font-weight: 600 !important;
            cursor: pointer !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
            transition: all 0.2s ease !important;
            color: white !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1) !important;
        }
        
        /* Blue/Lavender buttons from screenshot */
        .btn-primary, .btn-warning, .btn-secondary {
            background: #628ce6 !important; /* Matching the screenshot blue */
        }

        .btn-primary:hover, .btn-warning:hover, .btn-secondary:hover {
            opacity: 0.9 !important;
            transform: translateY(-1px) !important;
            box-shadow: 0 6px 10px -1px rgba(0, 0, 0, 0.15) !important;
        }

        .btn img {
            width: 16px !important;
            height: 16px !important;
            filter: brightness(0) invert(1) !important; /* Make icons white */
        }

        @media (max-width: 1024px) {
            .profile-container {
                margin-left: 280px !important;
                padding: 20px !important;
            }
            .form-row {
                grid-template-columns: 1fr !important;
                gap: 20px !important;
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
                            <input type="tel" name="phone" value="${user.phone}" placeholder="Số điện thoại của bạn" required>
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
