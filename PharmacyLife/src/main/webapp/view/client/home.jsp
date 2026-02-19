<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PharmacyLife - Danh sách Thuốc</title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="<c:url value='/assets/css/header.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/home-page.css'/>" rel="stylesheet">
                </head>

                <body>
                    <%@ include file="../common/header.jsp" %>

                        <div class="main-content">
                            <div class="container">
                                <c:choose>
                                    <c:when test="${not empty allMedicines}">
                                        <div class="row g-3">
                                            <c:forEach var="medicine" items="${allMedicines}">
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
                                        <div class="alert alert-info" role="alert">
                                            <i class="fas fa-info-circle"></i> Không có thuốc nào trong hệ thống.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <%@ include file="../common/footer.jsp" %>

                            <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>