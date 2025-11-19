@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TRAVEL_SB1
  as select from ztravel_sb1 as Travel
{
  key travel_id                                               as TravelId,
      agency_id                                               as AgencyId,
      customer_id                                             as CustomerId,
      begin_date                                              as BeginDate,
      end_date                                                as EndDate,
      destination                                             as Destination,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee                                             as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price                                             as TotalPrice,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_CurrencyStdVH',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      currency_code                                           as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      division(5 * cast(total_price as abap.dec(15,2)),100,2) as VatTax,
      description                                             as Description,
      status                                                  as Status,
      @Semantics.user.createdBy: true
      created_by                                              as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                              as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by                                   as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                   as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                         as LastChangedAt

}
