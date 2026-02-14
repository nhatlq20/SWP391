<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="sidebar">
    <ul class="sidebar-menu">
        <li><a href="#"><span style="font-size: 18px;">👤</span> Thông tin cá nhân</a></li>
        <li><a href="#"><span style="font-size: 18px;">📋</span> Quản lí thuốc</a></li>
        <li><a href="#"><span style="font-size: 18px;">📊</span> Quản lí danh mục</a></li>
        <li><a href="#"><span style="font-size: 18px;">✓</span> Quản lí đơn hàng</a></li>
        <li><a href="${pageContext.request.contextPath}/ImportController" class="active"><span style="font-size: 18px;">📥</span> Quản lí nhập thuốc</a></li>
        <li><a href="#"><span style="font-size: 18px;">👥</span> Quản lí nhân viên</a></li>
        <li><a href="#"><span style="font-size: 18px;">👫</span> Quản lí khách hàng</a></li>
        <li class="logout-link"><a href="#"><span style="font-size: 18px; color: #dc3545;">→</span> Đăng xuất</a></li>
    </ul>
</div>
