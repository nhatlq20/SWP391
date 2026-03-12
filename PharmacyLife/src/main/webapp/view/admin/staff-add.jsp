<%-- Document : staff-add Created on : Feb 13, 2026, 1:20:29 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Thêm nhân viên</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body class="bg-light">

                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content staff-main">
                    <div class="staff-page">

                        <div class="form-card">
                            <div class="form-card-header">
                                <h3><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm nhân viên mới</h3>
                            </div>
                            <div class="form-card-body">
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger" style="margin-bottom: 16px;">
                                        ${errorMessage}
                                    </div>
                                </c:if>

                                <div id="clientStaffError" class="alert alert-danger" style="display: none; margin-bottom: 16px;"></div>

                                <form method="POST" action="${pageContext.request.contextPath}/admin/manage-staff?action=insert"
                                    class="staff-form" id="staffAddForm">

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffName" class="form-label">
                                                    <i class="fas fa-user-tag me-1"></i> Họ và tên nhân viên
                                                </label>
                                                <input type="text" id="staffName" name="staffName"
                                                    placeholder="Họ và tên nhân viên" required class="form-control" value="${staffName}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-user-shield me-1"></i> Chức vụ
                                                </label>
                                                <input class="form-control" value="Nhân viên" readonly>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffEmail" class="form-label">
                                                    <i class="fas fa-envelope me-1"></i> Email
                                                </label>
                                                <input type="email" id="staffEmail" name="staffEmail"
                                                    placeholder="Email nhân viên" required class="form-control" value="${staffEmail}" maxlength="254">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffPassword" class="form-label">
                                                    <i class="fas fa-lock me-1"></i> Mật khẩu
                                                </label>
                                                <input type="password" id="staffPassword" name="staffPassword"
                                                    placeholder="Mật khẩu" required class="form-control" minlength="8" maxlength="16">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffPhone" class="form-label">
                                                    <i class="fas fa-phone me-1"></i> Số điện thoại
                                                </label>
                                                <input type="text" id="staffPhone" name="staffPhone"
                                                    placeholder="Số điện thoại" class="form-control">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffDob" class="form-label">
                                                    <i class="fas fa-calendar-alt me-1"></i> Ngày sinh
                                                </label>
                                                <input type="date" id="staffDob" name="staffDob" class="form-control">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffGender" class="form-label">
                                                    <i class="fas fa-venus-mars me-1"></i> Giới tính
                                                </label>
                                                <select id="staffGender" name="staffGender" class="form-select">
                                                    <option value="Nam">Nam</option>
                                                    <option value="Nữ">Nữ</option>
                                                    <option value="Khác">Khác</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffAddress" class="form-label">
                                                    <i class="fas fa-map-marker-alt me-1"></i> Địa chỉ
                                                </label>
                                                <input type="text" id="staffAddress" name="staffAddress"
                                                    placeholder="Địa chỉ" class="form-control">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-actions d-flex justify-content-between align-items-center mt-5">
                                        <a href="${pageContext.request.contextPath}/admin/manage-staff" class="btn-cancel">
                                            <i class="fas fa-chevron-left"></i> Trở lại
                                        </a>
                                        <button type="submit" class="btn-submit">
                                            <i class="fas fa-plus-circle"></i> Thêm nhân viên
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>

            </body>

            <script>
                const staffAddForm = document.getElementById("staffAddForm");
                const staffNameInput = document.getElementById("staffName");
                const staffEmailInput = document.getElementById("staffEmail");
                const staffPasswordInput = document.getElementById("staffPassword");
                const clientStaffError = document.getElementById("clientStaffError");

                function showClientStaffError(message) {
                    if (!clientStaffError) {
                        return;
                    }
                    clientStaffError.textContent = message;
                    clientStaffError.style.display = "block";
                }

                function hideClientStaffError() {
                    if (!clientStaffError) {
                        return;
                    }
                    clientStaffError.textContent = "";
                    clientStaffError.style.display = "none";
                }

                function normalizeName(value) {
                    return value ? value.trim().replace(/\s+/g, " ") : "";
                }

                if (staffAddForm) {
                    staffAddForm.addEventListener("submit", function (event) {
                        hideClientStaffError();

                        const normalizedName = normalizeName(staffNameInput.value);
                        const normalizedEmail = staffEmailInput.value.trim().toLowerCase();
                        const passwordValue = staffPasswordInput.value;
                        const dobValue = document.getElementById("staffDob").value;

                        const fullNameRegex = /^[\p{L}][\p{L}\s'.-]{1,99}$/u;
                        const emailRegex = /^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*@(gmail\.com|yahoo\.com|fucantho|fucantho\.edu\.vn|pharmacy\.com|pharmacylife\.com)$/;

                        staffNameInput.value = normalizedName;
                        staffEmailInput.value = normalizedEmail;

                        if (!normalizedName || !normalizedEmail || !passwordValue) {
                            event.preventDefault();
                            showClientStaffError("Vui lòng nhập đầy đủ thông tin!");
                            return;
                        }

                        if (dobValue) {
                            const dobDate = new Date(dobValue);
                            const today = new Date();
                            let age = today.getFullYear() - dobDate.getFullYear();
                            const monthDiff = today.getMonth() - dobDate.getMonth();
                            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dobDate.getDate())) {
                                age--;
                            }

                            if (age < 18 || age > 80) {
                                event.preventDefault();
                                showClientStaffError("Tuổi nhân viên phải từ 18 đến 80!");
                                return;
                            }
                        }

                        if (!fullNameRegex.test(normalizedName)) {
                            event.preventDefault();
                            showClientStaffError("Họ tên không hợp lệ!");
                            return;
                        }

                        if (normalizedEmail.length > 254 || !emailRegex.test(normalizedEmail)) {
                            event.preventDefault();
                            showClientStaffError("Email không chính xác!");
                            return;
                        }

                        if (passwordValue.length < 8 || passwordValue.length > 16) {
                            event.preventDefault();
                            showClientStaffError("mật khẩu phải có độ dài từ 8 đến 16 kí tự");
                        }
                    });

                    [staffNameInput, staffEmailInput, staffPasswordInput].forEach(function (input) {
                        if (input) {
                            input.addEventListener("input", hideClientStaffError);
                        }
                    });
                }
            </script>

            </html>