<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - PharmacyLife</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="<c:url value='/assets/css/product.css'/>" rel="stylesheet">
    </head>
    <body>
        <%@ include file="../common/header.jsp" %>
    
    <div class="container-admin" style="margin-top: 20px;">
        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${medicines.size()}</div>
                    <div class="stats-label">Tổng Sản Phẩm</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" style="color: #28a745;">
                        <c:set var="inStockCount" value="0" />
                        <c:forEach var="med" items="${medicines}">
                            <c:if test="${med.remainingQuantity > 0}">
                                <c:set var="inStockCount" value="${inStockCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${inStockCount}
                    </div>
                    <div class="stats-label">Còn Hàng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" style="color: #dc3545;">
                        <c:set var="outStockCount" value="0" />
                        <c:forEach var="med" items="${medicines}">
                            <c:if test="${med.remainingQuantity <= 0}">
                                <c:set var="outStockCount" value="${outStockCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${outStockCount}
                    </div>
                    <div class="stats-label">Hết Hàng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" style="color: #ffc107;">
                        <c:set var="lowStockCount" value="0" />
                        <c:forEach var="med" items="${medicines}">
                            <c:if test="${med.remainingQuantity > 0 && med.remainingQuantity < 20}">
                                <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${lowStockCount}
                    </div>
                    <div class="stats-label">Sắp Hết Hàng</div>
                </div>
            </div>
        </div>
        
        <!-- Product Table -->
        <div class="card">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h3><i class="fas fa-list me-2"></i>Danh Sách Sản Phẩm</h3>
                    <button class="btn btn-add" onclick="location.href='#'">
                        <i class="fas fa-plus me-2"></i>Thêm Sản Phẩm
                    </button>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-container">
                    <c:choose>
                        <c:when test="${empty medicines}">
                            <div class="empty-state">
                                <i class="fas fa-inbox"></i>
                                <h3>Chưa có sản phẩm nào</h3>
                                <p>Hãy thêm sản phẩm đầu tiên của bạn</p>
                                <button class="btn btn-add mt-3">
                                    <i class="fas fa-plus me-2"></i>Thêm Sản Phẩm
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã SP</th>
                                        <th>Tên Sản Phẩm</th>
                                        <th>Giá</th>
                                        <th>Đơn Vị</th>
                                        <th>Danh Mục</th>
                                        <th>Số Lượng</th>
                                        <th>Trạng Thái</th>
                                        <th width="150">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="medicine" items="${medicines}">
                                        <tr>
                                            <td><strong>${medicine.medicineID}</strong></td>
                                            <td>
                                                <div class="product-name">${medicine.medicineName}</div>
                                                <small class="text-muted">${medicine.packDescription}</small>
                                            </td>
                                            <td>
                                                <span class="price">
                                                    <c:if test="${medicine.sellingPrice != null}">
                                                        <fmt:formatNumber value="${medicine.sellingPrice}" type="number" groupingUsed="true" />₫
                                                    </c:if>
                                                    <c:if test="${medicine.sellingPrice == null}">N/A</c:if>
                                                </span>
                                            </td>
                                            <td>${medicine.unit}</td>
                                            <td>${medicine.categoryID}</td>
                                            <td>
                                                <strong>${medicine.remainingQuantity}</strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${medicine.remainingQuantity > 20}">
                                                        <span class="badge badge-stock">Còn Hàng</span>
                                                    </c:when>
                                                    <c:when test="${medicine.remainingQuantity > 0}">
                                                        <span class="badge badge-low">Sắp Hết</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-out">Hết Hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="btn btn-action btn-edit" onclick="editProduct('${medicine.medicineID}')">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                                <button class="btn btn-action btn-delete" onclick="confirmDelete('${medicine.medicineID}', '${medicine.medicineName}')">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(id, name) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm "' + name + '"?')) {
                window.location.href = 'product?action=delete&id=' + id;
            }
        }
        
        function editProduct(id) {
            // Implement edit functionality
            alert('Chức năng sửa sản phẩm "' + id + '" sẽ được triển khai sau');
        }
    </script>
    
    <%@ include file="../common/footer.jsp" %>
    </body>
</html>
