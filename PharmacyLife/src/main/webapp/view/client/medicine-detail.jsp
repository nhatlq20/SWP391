<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <c:out value="${medicine.medicineName}" />
                    </title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/assets/css/client-header.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/assets/css/detail.css" rel="stylesheet">
                </head>

                <body>
                    <%@ include file="../common/header.jsp" %>

                        <div class="detail-wrapper">
                            <div class="detail-content">
                                <!-- Main Product Info -->
                                <div class="row g-5">
                                    <!-- Left: Product Image -->
                                    <div class="col-12 col-lg-4">
                                        <div class="product-image-section">
                                            <div class="product-image-box">
                                                <c:choose>
                                                    <c:when test="${not empty medicine.imageUrl}">
                                                        <c:set var="imageUrlTrimmed"
                                                            value="${fn:trim(medicine.imageUrl)}" />
                                                        <c:choose>
                                                            <c:when
                                                                test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                <c:set var="imgSrc" value="${imageUrlTrimmed}" />
                                                            </c:when>
                                                            <c:when test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                                <c:set var="imgSrc"
                                                                    value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                            </c:when>
                                                            <c:when
                                                                test="${fn:contains(imageUrlTrimmed, 'assets/img')}">
                                                                <c:set var="imgSrc"
                                                                    value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="imgSrc"
                                                                    value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <img src="<c:out value='${imgSrc}'/>"
                                                            alt="<c:out value='${medicine.medicineName}'/>" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                            alt="<c:out value='${medicine.medicineName}'/>" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right: Product Details -->
                                    <div class="col-12 col-lg-8 product-info-section">
                                        <!-- Title -->
                                        <h2>
                                            <c:out value='${medicine.medicineName}' />
                                        </h2>

                                        <!-- Rating & Comments -->
                                        <div class="rating-show">
                                            <div class="rating-stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star-half-alt"></i>
                                            </div>
                                            <span class="rating-text">5 • <strong>88 bình luận</strong></span>
                                        </div>

                                        <!-- Meta Info -->
                                        <div class="meta-info">
                                            <span><strong>MED001</strong></span>
                                            <span>Đánh giá sản phẩm (1 đánh giá)</span>
                                        </div>

                                        <!-- Price -->
                                        <div class="price-section">
                                            <span class="price-value">
                                                <c:choose>
                                                    <c:when
                                                        test="${medicine.sellingPrice != null && medicine.sellingPrice > 0}">
                                                        <fmt:formatNumber value="${medicine.sellingPrice}" type="number"
                                                            groupingUsed="true" />₫
                                                    </c:when>
                                                    <c:otherwise>
                                                        Giá tham khảo
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="price-unit">/
                                                <c:out value='${medicine.unit}' />
                                            </span>
                                        </div>

                                        <!-- Unit (display only) -->
                                        <div class="form-group">
                                            <label>Đơn vị tính</label>
                                            <div class="unit-options">
                                                <span class="unit-text">
                                                    <c:out value='${medicine.unit}' />
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Quantity Selection -->
                                        <div class="mb-3">
                                            <label class="form-label">Chọn số lượng</label>
                                            <div class="input-group" style="max-width:180px">
                                                <button class="btn btn-outline-secondary" type="button"
                                                    onclick="decreaseQty()">−</button>
                                                <input type="number" id="quantity" class="form-control text-center"
                                                    value="1" min="1">
                                                <button class="btn btn-outline-secondary" type="button"
                                                    onclick="increaseQty()">+</button>
                                            </div>
                                        </div>

                                        <!-- Category -->
                                        <div class="category-section">
                                            <span class="category-label">Danh mục:</span>
                                            <span class="category-value">Thuốc dị ứng</span>
                                        </div>

                                        <!-- Description -->
                                        <div class="description-section">
                                            <span class="section-title">Mô tả ngắn:</span>
                                            <p class="section-content">
                                                <c:out value='${medicine.shortDescription}' />
                                            </p>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="action-buttons">
                                            <button class="btn-buy btn btn-primary">Mua</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Review Section -->
                                <div class="review-section">
                                    <h3 class="review-title">Đánh giá sản phẩm</h3>

                                    <!-- Rating Distribution -->
                                    <div class="rating-distribution">
                                        <div class="rating-item">
                                            <div class="rating-stars-count">
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                            </div>
                                            <div class="rating-bar-wrapper">
                                                <div class="rating-bar">
                                                    <div class="rating-bar-fill" style="width: 100%;"></div>
                                                </div>
                                            </div>
                                            <span>(1)</span>
                                        </div>
                                        <div class="rating-item">
                                            <div class="rating-stars-count">
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #ddd;"></i>
                                            </div>
                                            <div class="rating-bar-wrapper">
                                                <div class="rating-bar">
                                                    <div class="rating-bar-fill" style="width: 0%;"></div>
                                                </div>
                                            </div>
                                            <span>(0)</span>
                                        </div>
                                        <div class="rating-item">
                                            <div class="rating-stars-count">
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #FFD700;"></i>
                                                <i class="fas fa-star" style="color: #ddd;"></i>
                                                <i class="fas fa-star" style="color: #ddd;"></i>
                                            </div>
                                            <div class="rating-bar-wrapper">
                                                <div class="rating-bar">
                                                    <div class="rating-bar-fill" style="width: 0%;"></div>
                                                </div>
                                            </div>
                                            <span>(0)</span>
                                        </div>
                                    </div>
                                    <script
                                        src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                                    <script src="${pageContext.request.contextPath}/assets/js/detail.js"></script>
                </body>

                </html>