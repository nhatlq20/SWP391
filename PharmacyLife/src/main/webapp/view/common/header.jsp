<%@ page pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/assets/css/client-header.css" rel="stylesheet">

                <nav class="navbar header navbar-expand-lg">
                    <div class="container-fluid">
                        <a class="navbar-brand logo-link" href="${pageContext.request.contextPath}/home">
                            <div class="logo-text d-inline-block">
                                <span class="brand-name" style="font-size:1.25rem; font-weight:700;">PharmacyLife</span>
                            </div>
                        </a>

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                            aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <form class="d-flex ms-auto me-auto" role="search"
                                action="${pageContext.request.contextPath}/search" method="GET">
                                <div class="search-placeholder w-100 d-flex align-items-center">
                                    <i class="fas fa-search" style="color: #ccc;"></i>
                                    <input class="form-control border-0 ms-2" type="search" name="keyword"
                                        placeholder="Tìm kiếm sản phẩm..." aria-label="Search" value="${keyword}">
                                </div>
                            </form>

                            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">
                                <li class="nav-item me-2">
                                    <a class="nav-link text-white" href="#"><i class="fas fa-user-circle"
                                            style="font-size:22px"></i></a>
                                </li>
                                <li class="nav-item me-2 d-none d-lg-inline">
                                    <span class="text-white" style="font-size:13px">User Name</span>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link text-white" href="#"><i
                                            class="fas fa-shopping-cart cart-icon"></i></a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>