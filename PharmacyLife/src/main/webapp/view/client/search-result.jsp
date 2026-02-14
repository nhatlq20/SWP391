<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Kết quả tìm kiếm - PharmacyLife</title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="<c:url value='/assets/css/header.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/home-page.css'/>" rel="stylesheet">
                    <style>
                        .search-header {
                            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                            padding: 30px 0;
                            margin-bottom: 25px;
                            border-radius: 0 0 15px 15px;
                        }

                        .search-header h2 {
                            color: #2c3e50;
                            font-weight: 700;
                            font-size: 22px;
                            margin-bottom: 5px;
                        }

                        .search-header .keyword-highlight {
                            color: #007bff;
                            font-weight: 700;
                        }

                        .search-header .result-count {
                            color: #6c757d;
                            font-size: 14px;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                        }

                        .empty-state i {
                            font-size: 64px;
                            color: #dee2e6;
                            margin-bottom: 20px;
                        }

                        .empty-state h4 {
                            color: #6c757d;
                            margin-bottom: 10px;
                        }

                        .empty-state p {
                            color: #adb5bd;
                            font-size: 14px;
                        }

                        .back-link {
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                            color: #007bff;
                            text-decoration: none;
                            font-size: 14px;
                            margin-bottom: 15px;
                        }

                        .back-link:hover {
                            text-decoration: underline;
                        }
                    </style>
                </head>

                <body>
                    <%@ include file="../common/header.jsp" %>

                        <div class="main-content">
                            <div class="container">

                                <!-- Back link -->
                                <a href="${pageContext.request.contextPath}/home" class="back-link">
                                    <i class="fas fa-arrow-left"></i> Quay lại trang chủ
                                </a>

                                <!-- Search header -->
                                <div class="search-header rounded p-4 mb-4">
                                    <c:choose>
                                        <c:when test="${not empty keyword}">
                                            <h2><i class="fas fa-search me-2"></i>Kết quả tìm kiếm cho:
                                                <span class="keyword-highlight">"
                                                    <c:out value='${keyword}' />"
                                                </span>
                                            </h2>
                                            <span class="result-count">Tìm thấy <strong>${resultCount}</strong> sản
                                                phẩm</span>
                                        </c:when>
                                        <c:otherwise>
                                            <h2><i class="fas fa-search me-2"></i>Tìm kiếm sản phẩm</h2>
                                            <span class="result-count">Vui lòng nhập từ khóa để tìm kiếm</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Search results -->
                                <c:choose>
                                    <c:when test="${not empty medicines}">
                                        <div class="row g-3">
                                            <c:forEach var="medicine" items="${medicines}">
                                                <div class="col-6 col-md-4 col-lg-3">
                                                    <div class="card h-100 medicine-card"
                                                        onclick="window.location.href='${pageContext.request.contextPath}/medicine/detail?id=${medicine.medicineID}'">
                                                        <c:choose>
                                                            <c:when test="${not empty medicine.imageUrl}">
                                                                <c:set var="imageUrlTrimmed"
                                                                    value="${fn:trim(medicine.imageUrl)}" />
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                        <c:set var="imgSrc"
                                                                            value="${imageUrlTrimmed}" />
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                                        <c:set var="imgSrc"
                                                                            value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:set var="imgSrc"
                                                                            value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <img src="${imgSrc}" alt="${medicine.medicineName}"
                                                                    class="card-img-top img-fluid"
                                                                    onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/no-image.png';">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                                    alt="${medicine.medicineName}"
                                                                    class="medicine-card-image card-img-top">
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div class="card-body d-flex flex-column">
                                                            <h5 class="card-title text-truncate medicine-name">
                                                                <c:out value='${medicine.medicineName}' />
                                                            </h5>
                                                            <div class="mt-auto">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center mb-2">
                                                                    <div class="fw-bold text-danger medicine-price">
                                                                        <fmt:formatNumber
                                                                            value="${medicine.sellingPrice}"
                                                                            type="number" groupingUsed="true" />₫
                                                                    </div>
                                                                    <div class="text-muted small medicine-unit">
                                                                        <c:out value='${medicine.unit}' />
                                                                    </div>
                                                                </div>
                                                                <a class="btn btn-primary w-100"
                                                                    href="${pageContext.request.contextPath}/medicine/detail?id=${medicine.medicineID}">Mua</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty keyword}">
                                            <div class="empty-state">
                                                <i class="fas fa-capsules"></i>
                                                <h4>Không tìm thấy sản phẩm nào</h4>
                                                <p>Không có kết quả cho từ khóa "
                                                    <c:out value='${keyword}' />". Hãy thử tìm kiếm với từ khóa khác.
                                                </p>
                                                <a href="${pageContext.request.contextPath}/home"
                                                    class="btn btn-outline-primary mt-3">
                                                    <i class="fas fa-home me-1"></i> Về trang chủ
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>

                        <%@ include file="../common/footer.jsp" %>

                            <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>