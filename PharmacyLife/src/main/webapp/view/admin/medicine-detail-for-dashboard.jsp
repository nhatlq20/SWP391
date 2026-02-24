<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết thuốc - PharmacyLife</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                </head>

                <body class="bg-light">
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <div class="detail-card">
                            <div class="detail-card-header">
                                <h3><i class="fas fa-pills me-2 text-primary"></i>Chi tiết thuốc</h3>
                                <a href="${pageContext.request.contextPath}/admin/medicine-edit-dashboard?id=${medicine.medicineId}"
                                    class="btn-edit-detail">
                                    <i class="fas fa-pen"></i> Chỉnh sửa
                                </a>
                            </div>
                            <div class="detail-card-body">
                                <!-- Medicine Image -->
                                <div class="detail-img-container">
                                    <c:choose>
                                        <c:when test="${not empty medicine.imageUrl}">
                                            <c:set var="imageUrlTrimmed" value="${fn:trim(medicine.imageUrl)}" />
                                            <c:set var="imgSrc" value="" />
                                            <c:choose>
                                                <c:when
                                                    test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                    <c:set var="imgSrc" value="${imageUrlTrimmed}" />
                                                </c:when>
                                                <c:when test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                    <c:set var="imgSrc"
                                                        value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                </c:when>
                                                <c:when test="${fn:contains(imageUrlTrimmed, 'assets')}">
                                                    <c:set var="imgSrc"
                                                        value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="imgSrc"
                                                        value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                </c:otherwise>
                                            </c:choose>
                                            <img src="<c:out value='${imgSrc}'/>" alt="${medicine.medicineName}"
                                                class="detail-img"
                                                onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div class=\'detail-img-placeholder\'><i class=\'fas fa-pills\'></i></div>';">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="detail-img-placeholder"><i class="fas fa-pills"></i></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Info Grid -->
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">Mã thuốc</div>
                                        <div class="info-value">${medicine.medicineCode}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Danh mục</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty medicine.category}">
                                                    ${medicine.category.categoryName}
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-item full-width">
                                        <div class="info-label">Tên thuốc</div>
                                        <div class="info-value">${medicine.medicineName}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Giá bán</div>
                                        <div class="info-value price-value">
                                            <fmt:formatNumber value="${medicine.sellingPrice}" type="number"
                                                groupingUsed="true" />đ
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Giá gốc</div>
                                        <div class="info-value">
                                            <fmt:formatNumber value="${medicine.originalPrice}" type="number"
                                                groupingUsed="true" />đ
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Đơn vị</div>
                                        <div class="info-value">${medicine.unit}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Số lượng tồn kho</div>
                                        <div class="info-value">
                                            ${medicine.remainingQuantity}
                                            <c:choose>
                                                <c:when test="${medicine.remainingQuantity > 20}">
                                                    <span class="badge badge-stock ms-2">Còn hàng</span>
                                                </c:when>
                                                <c:when test="${medicine.remainingQuantity > 0}">
                                                    <span class="badge badge-low ms-2">Sắp hết</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-out ms-2">Hết hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Thương hiệu / Xuất xứ</div>
                                        <div class="info-value">${not empty medicine.brandOrigin ? medicine.brandOrigin
                                            : '—'}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Đường dẫn ảnh</div>
                                        <div class="info-value" style="word-break: break-all; font-size: 0.85rem;">
                                            ${not empty medicine.imageUrl ? medicine.imageUrl : '—'}
                                        </div>
                                    </div>
                                    <div class="info-item full-width">
                                        <div class="info-label">Mô tả</div>
                                        <div class="info-value">${not empty medicine.shortDescription ?
                                            medicine.shortDescription : '—'}</div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/products-dashboard"
                                        class="btn-back">
                                        <i class="fas fa-chevron-left"></i> Trở lại danh sách
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>