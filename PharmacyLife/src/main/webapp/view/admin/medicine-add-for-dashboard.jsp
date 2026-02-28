<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm thuốc mới - PharmacyLife</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
        </head>

        <body class="bg-light">
            <jsp:include page="/view/common/header.jsp" />
            <jsp:include page="/view/common/sidebar.jsp" />

            <div class="main-content">
                <div class="form-card">
                    <div class="form-card-header">
                        <h3><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm thuốc mới</h3>
                    </div>
                    <div class="form-card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/admin/medicine-add-dashboard">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">Mã thuốc</label>
                                    <input name="medicineCode" class="form-control" value="${nextMedicineCode}" readonly
                                        style="background-color:#e9ecef; cursor:not-allowed;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Danh mục</label>
                                    <select name="categoryId" class="form-select" required>
                                        <option value="">Chọn danh mục của thuốc</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ảnh</label>
                                    <input name="imageUrl" class="form-control" placeholder="Nhập đường dẫn ảnh">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Số lượng</label>
                                    <input name="remainingQuantity" type="number" min="0" class="form-control"
                                        placeholder="Nhập số lượng" value="0">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Tên thuốc</label>
                                    <input name="medicineName" class="form-control" placeholder="Nhập tên thuốc"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá bán (đ)</label>
                                    <input name="sellingPrice" type="number" step="0.01" min="0" class="form-control"
                                        placeholder="Nhập giá thuốc">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Thương hiệu / xuất xứ</label>
                                    <input name="brandOrigin" class="form-control"
                                        placeholder="Nhập thương hiệu / xuất xứ">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Đơn vị</label>
                                    <select name="unit" class="form-select">
                                        <option value="Hộp">Hộp</option>
                                        <option value="Vỉ">Vỉ</option>
                                        <option value="Chai">Chai</option>
                                        <option value="Tuýp">Tuýp</option>
                                        <option value="Gói">Gói</option>
                                        <option value="Lọ">Lọ</option>
                                        <option value="Viên">Viên</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá gốc (đ)</label>
                                    <input name="originalPrice" type="number" step="0.01" min="0" class="form-control"
                                        placeholder="Nhập giá gốc">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="shortDescription" rows="4" class="form-control"
                                        placeholder="Nhập mô tả của thuốc"></textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="${pageContext.request.contextPath}/admin/medicines-dashboard" class="btn-back">
                                    <i class="fas fa-chevron-left"></i> Trở lại
                                </a>
                                <button type="submit" class="btn-submit">
                                    <i class="fas fa-plus-circle"></i> Thêm thuốc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>