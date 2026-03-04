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
                <c:set var="displayedSuccess" value="false" />
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${successMessage}</span>
                    </div>
                    <c:set var="displayedSuccess" value="true" />
                </c:if>

                <!-- Session Success Message (only if not already displayed) -->
                <c:if test="${not empty sessionScope.successMessage && !displayedSuccess}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${sessionScope.successMessage}</span>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.successMessage && displayedSuccess}">
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${errorMessage}</span>
                </div>
                </c:if>

                <div id="clientProfileError" class="alert alert-error" style="display: none !important;">
                    <i class="fas fa-exclamation-circle"></i>
                    <span id="clientProfileErrorText"></span>
                </div>

                <form action="${pageContext.request.contextPath}/profile" method="post" class="profile-form">
                    <!-- Row 1: Full Name & Phone -->
                    <div class="form-row">
                        <div class="form-field">
                            <label>
                                <img src="${pageContext.request.contextPath}/assets/img/fname.png" alt="Name">
                                Họ và tên của bạn
                            </label>
                            <input type="text" name="fullName" value="${user.fullName}" placeholder="Họ và tên của bạn" required
                                   ${user.roleID == 1 || user.roleID == 2 ? 'disabled style="background-color: #e9ecef; cursor: not-allowed;"' : ''}>
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
                            <c:choose>
                                <c:when test="${user.roleID == 1 || user.roleID == 2}">
                                    <input type="text" value="${user.gender}" disabled style="background-color: #e9ecef; cursor: not-allowed;">
                                    <input type="hidden" name="gender" value="${user.gender}">
                                </c:when>
                                <c:otherwise>
                                    <select name="gender">
                                        <option value="" disabled ${empty user.gender ? 'selected' : ''}>Giới tính của bạn</option>
                                        <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="form-field">
                            <label>
                                <img src="${pageContext.request.contextPath}/assets/img/dob.png" alt="DOB">
                                Ngày sinh
                            </label>
                            <input type="date" name="dob" value="<fmt:formatDate value='${user.dob}' pattern='yyyy-MM-dd' />" 
                                   placeholder="Ngày sinh của bạn" ${user.roleID == 1 || user.roleID == 2 ? 'disabled style="background-color: #e9ecef; cursor: not-allowed;"' : ''}>
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
                        <input type="text" name="address" value="${user.address}" placeholder="Địa chỉ của bạn"
                               ${user.roleID == 1 || user.roleID == 2 ? 'disabled style="background-color: #e9ecef; cursor: not-allowed;"' : ''}>
                    </div>

                    <!-- Buttons -->
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <img src="${pageContext.request.contextPath}/assets/img/save.png" alt="Save">
                            Lưu
                        </button>
                        
                        <c:if test="${user.roleID == 0}">
                            <button type="button" class="btn btn-warning" onclick="window.location.href='${pageContext.request.contextPath}/change-email'" style="background-color: #4F81E1; border-color: #4F81E1;">
                                <img src="${pageContext.request.contextPath}/assets/img/email.png" alt="Change Email">
                                Thay đổi Email
                            </button>
                        </c:if>
                        
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/change-password'">
                            <img src="${pageContext.request.contextPath}/assets/img/pass.png" alt="Change Password">
                            Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        const profileForm = document.querySelector(".profile-form");
        const fullNameInput = profileForm ? profileForm.querySelector('input[name="fullName"]') : null;
        const phoneInput = profileForm ? profileForm.querySelector('input[name="phone"]') : null;
        const dobInput = profileForm ? profileForm.querySelector('input[name="dob"]') : null;
        const addressInput = profileForm ? profileForm.querySelector('input[name="address"]') : null;
        const clientProfileError = document.getElementById("clientProfileError");
        const clientProfileErrorText = document.getElementById("clientProfileErrorText");

        function showProfileError(message) {
            if (!clientProfileError || !clientProfileErrorText) {
                return;
            }
            clientProfileErrorText.textContent = message;
            clientProfileError.style.setProperty("display", "flex", "important");
        }

        function hideProfileError() {
            if (!clientProfileError || !clientProfileErrorText) {
                return;
            }
            clientProfileErrorText.textContent = "";
            clientProfileError.style.setProperty("display", "none", "important");
        }

        function normalizeSpaces(value) {
            return value ? value.trim().replace(/\s+/g, " ") : "";
        }

        function normalizePhone(value) {
            return value ? value.trim().replace(/[\s.-]/g, "") : "";
        }

        if (dobInput) {
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, "0");
            const dd = String(today.getDate()).padStart(2, "0");
            dobInput.max = `${yyyy}-${mm}-${dd}`;
        }

        if (profileForm) {
            profileForm.addEventListener("submit", function (event) {
                hideProfileError();

                const normalizedFullName = normalizeSpaces(fullNameInput ? fullNameInput.value : "");
                const normalizedPhone = normalizePhone(phoneInput ? phoneInput.value : "");
                const normalizedAddress = normalizeSpaces(addressInput ? addressInput.value : "");

                const fullNameRegex = /^[\p{L}][\p{L}\s'.-]{1,99}$/u;
                const phoneRegex = /^0\d{9}$/;
                const addressRegex = /^[\p{L}\p{N}\s.,-]+$/u;

                if (fullNameInput) {
                    fullNameInput.value = normalizedFullName;
                }
                if (phoneInput) {
                    phoneInput.value = normalizedPhone;
                }
                if (addressInput) {
                    addressInput.value = normalizedAddress;
                }

                if (!normalizedFullName || !fullNameRegex.test(normalizedFullName)) {
                    event.preventDefault();
                    showProfileError("Họ tên không hợp lệ!");
                    return;
                }

                if (normalizedPhone && !phoneRegex.test(normalizedPhone)) {
                    event.preventDefault();
                    showProfileError("Số điện thoại phải bắt đầu bằng 0 và có đúng 10 số!");
                    return;
                }

                if (dobInput && dobInput.value) {
                    const selectedDate = new Date(dobInput.value + "T00:00:00");
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    if (selectedDate > today) {
                        event.preventDefault();
                        showProfileError("Ngày sinh không được vượt quá thời điểm hiện tại!");
                        return;
                    }
                }

                if (normalizedAddress && !addressRegex.test(normalizedAddress)) {
                    event.preventDefault();
                    showProfileError("Địa chỉ không hợp lệ! Chỉ được dùng chữ, số, khoảng trắng và các ký tự . , -");
                }
            });

            [fullNameInput, phoneInput, dobInput, addressInput].forEach(function (input) {
                if (input) {
                    input.addEventListener("input", hideProfileError);
                    input.addEventListener("change", hideProfileError);
                }
            });
        }
    </script>
</body>
</html>
