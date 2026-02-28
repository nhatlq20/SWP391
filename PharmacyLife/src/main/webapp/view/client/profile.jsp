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
