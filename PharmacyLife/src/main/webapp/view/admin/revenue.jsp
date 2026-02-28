<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lí doanh thu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/revenue-dashboard.css">
</head>
<body>
    <!-- ================= HEADER ================= -->
    <jsp:include page="/view/common/header.jsp"/>

    <div class="admin-layout">
        <!-- =============== SIDEBAR =============== -->
        <div class="sidebar-fixed">
            <jsp:include page="/view/common/sidebar.jsp"/>
        </div>

        <!-- ============= MAIN CONTENT ============= -->
        <div class="main-content" style="margin-top:115px; padding-top:32px;">
            <div class="container-fluid px-0">
                <div class="d-flex align-items-center mb-4">
                    <h3 class="fw-bold mb-0"><i class="fas fa-chart-line me-2 text-primary"></i>Quản lí doanh thu</h3>
                </div>
                <!-- KPI Section Title -->
                <div class="d-flex align-items-end mb-3" style="gap:12px;">
                    <div style="font-size:22px;font-weight:700;color:#2a60e8;">Tổng quan</div>
                </div>
                <!-- KPI Cards -->
                <div class="row gap-24 mb-4">
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="kpi-card kpi-orders text-center">
                            <div class="kpi-label">Số lượng đơn hàng</div>
                            <div class="kpi-value-main">${totalOrders}</div>
                            <div class="kpi-growth"><i class="fas fa-arrow-up text-success"></i> 15%</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="kpi-card kpi-value text-center">
                            <div class="kpi-label">Giá trị đơn hàng</div>
                            <div class="kpi-value-main"><fmt:formatNumber value="${totalRevenue/1000000}" maxFractionDigits="0"/> triệu</div>
                            <div class="kpi-growth"><i class="fas fa-arrow-up text-success"></i> 20%</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="kpi-card kpi-revenue text-center">
                            <div class="kpi-label">Thực thu</div>
                            <div class="kpi-value-main"><fmt:formatNumber value="${(totalRevenue-totalDebt)/1000000}" maxFractionDigits="0"/> triệu</div>
                            <div class="kpi-growth"><i class="fas fa-arrow-up text-success"></i> 20%</div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="kpi-card kpi-debt text-center">
                            <div class="kpi-label">Số còn phải thu</div>
                            <div class="kpi-value-main"><fmt:formatNumber value="${totalDebt/1000000}" maxFractionDigits="0"/> triệu</div>
                            <div class="kpi-growth"><i class="fas fa-arrow-up text-success"></i> 20%</div>
                        </div>
                    </div>
                </div>
                <!-- Order Status Section -->
                <div class="section-title">Thống kê đơn hàng</div>
                <div class="row gap-24">
                    <div class="col-12 col-md-4">
                        <div class="order-status-card">
                            <div class="order-status-title">Xử Lý</div>
                            <div><span class="status-dot dot-yellow"></span> Chờ xác nhận: <b>${statusStats['Chờ xác nhận']}</b></div>
                            <div><span class="status-dot dot-blue"></span> Đã xác nhận: <b>${statusStats['Đã xác nhận']}</b></div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="order-status-card">
                            <div class="order-status-title">Vận Chuyển</div>
                            <div><span class="status-dot dot-yellow"></span> Chưa giao hàng: <b>${statusStats['Chưa giao hàng']}</b></div>
                            <div><span class="status-dot dot-blue"></span> Đang giao: <b>${statusStats['Đang giao']}</b></div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="order-status-card">
                            <div class="order-status-title">Hoàn Tất</div>
                            <div><span class="status-dot dot-green"></span> Đã giao: <b>${statusStats['Đã giao']}</b></div>
                            <div><span class="status-dot dot-red"></span> Đã hủy: <b>${statusStats['Đã hủy']}</b></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/4e7e2e6e7b.js" crossorigin="anonymous"></script>
</body>
</html>
