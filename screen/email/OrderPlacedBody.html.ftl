<#list orderPartInfoList as orderPartInfo>
    <#assign orderPart = orderPartInfo.orderPart>
    <#assign contactInfo = orderPartInfo>

    <table border="0" cellpadding="8px" cellspacing="0" width="100%"><tr>
        <td width="50%">
            <#if detailLinkPath?has_content>
                <h2><a href="http://${storeDomain}/${detailLinkPath}?orderId=${orderId}">Order ${orderId} Part ${orderPart.orderPartSeqId}</a></h2>
            <#else>
                <h2>Order ${orderId} Part ${orderPart.orderPartSeqId}</h2>
            </#if>
            <h3>Total ${ec.l10n.formatCurrency(orderPart.partTotal, orderHeader.currencyUomId)}</h3>
            <h3>Placed on ${ec.l10n.format(orderHeader.placedDate, "dd MMM yyyy")}</h3>
            <h3>Placed by ${(orderPartInfo.customerDetail.firstName)!""} ${(orderPartInfo.customerDetail.middleName)!""} ${(orderPartInfo.customerDetail.lastName)!""}</h3>
        </td>
        <td width="50%">
            <#if orderPartInfo.shipmentMethodEnum?has_content>
                <strong>Ship By</strong> ${orderPartInfo.shipmentMethodEnum.description}<br/>
            </#if>
            <#if contactInfo.postalAddress?has_content>
                <#if contactInfo.postalAddress.toName?has_content || contactInfo.postalAddress.attnName?has_content>
                    <#if contactInfo.postalAddress.toName?has_content><strong>To: ${contactInfo.postalAddress.toName}</strong><br/></#if>
                    <#if contactInfo.postalAddress.attnName?has_content><strong>Attn: ${contactInfo.postalAddress.attnName}</strong><br/></#if>
                <#else>
                    <strong>${(orderPartInfo.customerDetail.firstName)!""} ${(orderPartInfo.customerDetail.middleName)!""} ${(orderPartInfo.customerDetail.lastName)!""}</strong><br/>
                </#if>
                ${(contactInfo.postalAddress.address1)!""}<#if contactInfo.postalAddress.unitNumber?has_content> #${contactInfo.postalAddress.unitNumber}</#if><br/>
                <#if contactInfo.postalAddress.address2?has_content>${contactInfo.postalAddress.address2}<br/></#if>
                ${contactInfo.postalAddress.city!""}, ${(contactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${contactInfo.postalAddress.postalCode!""}<#if contactInfo.postalAddress.postalCodeExt?has_content>-${contactInfo.postalAddress.postalCodeExt}</#if><#if contactInfo.postalAddress.countryGeoId?has_content> ${contactInfo.postalAddress.countryGeoId}</#if><br/>
            </#if>
            <#if contactInfo.telecomNumber?has_content>
                <#if contactInfo.telecomNumber.countryCode?has_content>${contactInfo.telecomNumber.countryCode}-</#if><#if contactInfo.telecomNumber.areaCode?has_content>${contactInfo.telecomNumber.areaCode}-</#if>${contactInfo.telecomNumber.contactNumber!""}<br/>
            </#if>
            <#if contactInfo.emailAddress?has_content>
                ${contactInfo.emailAddress}<br/>
            </#if>
        </td>
    </tr></table>
    <table border="0" cellpadding="8px" cellspacing="0" width="100%">
        <tr>
            <td align="center"><strong>Item</strong></td>
            <td><strong>Type</strong></td>
            <td><strong>Description</strong></td>
            <#-- <td><strong>Ship By</strong></td> -->
            <td align="center"><strong>Qty</strong></td>
            <td align="right"><strong>Amount</strong></td>
            <td align="right"><strong>Total</strong></td>
        </tr>
        <#list orderPartInfo.partOrderItemList as orderItem>
            <#assign itemTypeEnum = orderItem.findRelatedOne("ItemType#moqui.basic.Enumeration", true, false)>
            <#assign orderItemTotalOut = ec.service.sync().name("mantle.order.OrderServices.get#OrderItemTotal").parameter("orderItem", orderItem).call()>
            <tr>
                <td align="center">${orderItem.orderItemSeqId}</td>
                <td>${((itemTypeEnum.description)!"")?replace("Sales - ", "")}</td>
                <td>${orderItem.itemDescription!""}</td>
                <#-- <td>${ec.l10n.format(orderItem.requiredByDate, "dd MMM yyyy")}</td> -->
                <td align="center">${orderItem.quantity!"1"}</td>
                <td align="right">${ec.l10n.formatCurrency(orderItem.unitAmount!0, orderHeader.currencyUomId)}</td>
                <td align="right">${ec.l10n.formatCurrency(orderItemTotalOut.itemTotal, orderHeader.currencyUomId)}</td>
            </tr>
        </#list>
        <tr>
            <td align="center">&nbsp;</td>
            <td><strong>Total</strong></td>
            <td>&nbsp;</td>
            <#-- <td>&nbsp;</td> -->
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right"><strong>${ec.l10n.formatCurrency(orderPart.partTotal, orderHeader.currencyUomId)}</strong></td>
        </tr>
    </table>

    <#if orderPartInfo.orderPart.shippingInstructions?has_content>
        <strong>Shipping Instructions</strong><br/>
        ${orderPartInfo.orderPart.shippingInstructions}<br/>
    </#if>
    <#if orderPartInfo.orderPart.giftMessage?has_content>
        <strong>Gift Message</strong><br/>
        ${orderPartInfo.orderPart.giftMessage}<br/>
    </#if>
</#list>
