<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="import-details">
    <c:if test="${not empty details}">
        <c:forEach var="detail" items="${details}">
            <div class="detail-item">
                <span class="detail-code">${detail.medicineCode}</span>
                <span class="detail-name">${detail.medicineName}</span>
                <span class="detail-quantity">${detail.quantity}</span>
                <span class="detail-price"><fmt:formatNumber value="${detail.unitPrice}" type="number" maxFractionDigits="0"/></span>
                <span class="detail-total"><fmt:formatNumber value="${detail.totalPrice}" type="number" maxFractionDigits="0"/></span>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${empty details}">
        <p>Không có chi tiết</p>
    </c:if>
</div>

