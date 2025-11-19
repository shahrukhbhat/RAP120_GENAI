@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TRAVEL_SB1
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TRAVEL_SB1
{
  key TravelId,
  AgencyId,
  CustomerId,
  BeginDate,
  EndDate,
  Destination,
  BookingFee,
  TotalPrice,
  @Semantics.currencyCode: true
  CurrencyCode,
  Description,
  Status,
  CreatedBy,
  CreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
