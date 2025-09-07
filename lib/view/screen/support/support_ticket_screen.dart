import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_conversation_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'issue_type_screen.dart';

// ignore: must_be_immutable
class SupportTicketScreen extends StatelessWidget {
  bool first = true;
  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<SupportTicketProvider>(context, listen: false)
            .getSupportTicketList(context);
      }
    }

    return CustomExpandedAppBar(
      title: getTranslated('support_ticket', context),
      isGuestCheck: true,
      bottomChild: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => IssueTypeScreen())),
        child: Material(
          color: ColorResources.getColombiaBlue(context),
          elevation: 5,
          borderRadius: BorderRadius.circular(50),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                color: ColorResources.getFloatingBtn(context),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 35),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Text(getTranslated('new_ticket', context),
                  style: titilliumSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.FONT_SIZE_LARGE)),
            ),
          ]),
        ),
      ),
      child: Provider.of<SupportTicketProvider>(context).supportTicketList !=
          null
          ? Provider.of<SupportTicketProvider>(context)
          .supportTicketList
          .length !=
          0
          ? Consumer<SupportTicketProvider>(
        builder: (context, support, child) {
          List<SupportTicketModel> supportTicketList =
          support.supportTicketList.reversed.toList();

          // Debug: Print all tickets and their status
          print('🔍 [DEBUG] All tickets:');
          supportTicketList.forEach((ticket) {
            print(
                '🔍 [DEBUG] Ticket: ${ticket.subject} - Status: "${ticket.status}" (Type: ${ticket.status.runtimeType})');
          });

          // Separate open and closed tickets
          List<SupportTicketModel> openTickets = supportTicketList
              .where((ticket) => ticket.status == 'open')
              .toList();
          List<SupportTicketModel> closedTickets = supportTicketList
              .where((ticket) => ticket.status == 'closed')
              .toList();

          // Debug: Print filtered results
          print(
              '🔍 [DEBUG] Open tickets count: ${openTickets.length}');
          print(
              '🔍 [DEBUG] Closed tickets count: ${closedTickets.length}');
          openTickets.forEach((ticket) {
            print(
                '🔍 [DEBUG] Open ticket: ${ticket.subject} - Status: "${ticket.status}"');
          });
          closedTickets.forEach((ticket) {
            print(
                '🔍 [DEBUG] Closed ticket: ${ticket.subject} - Status: "${ticket.status}"');
          });

          return RefreshIndicator(
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
              await support.getSupportTicketList(context);
            },
            child: ListView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              children: [
                // Open Tickets Section
                if (openTickets.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Open Tickets',
                      openTickets.length, Colors.green),
                  ...openTickets
                      .map((ticket) => _buildTicketCard(
                      context,
                      ticket,
                      ticket.status == 'open'))
                      .toList(),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                ],

                // Closed Tickets Section
                if (closedTickets.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Closed Tickets',
                      closedTickets.length, Colors.grey),
                  ...closedTickets
                      .map((ticket) => _buildTicketCard(
                      context,
                      ticket,
                      ticket.status == 'open'))
                      .toList(),
                ],

                // Empty state if no tickets
                if (openTickets.isEmpty && closedTickets.isEmpty)
                  _buildEmptyState(context),
              ],
            ),
          );
        },
      )
          : NoInternetOrDataScreen(isNoInternet: false)
          : SupportTicketShimmer(),
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(
      BuildContext context, String title, int count, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Text(
            '$title ($count)',
            style: titilliumBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build ticket cards
  Widget _buildTicketCard(
      BuildContext context, SupportTicketModel ticket, bool isOpen) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SupportConversationScreen(
                  supportTicketModel: ticket,
                )));
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: ColorResources.getImageBg(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isOpen ? ColorResources.getPrimary(context) : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created: ${DateConverter.localDateToIsoStringAMPM(DateTime.parse(ticket.createdAt))}',
                        style: titilliumRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        ticket.subject,
                        style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  ),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? ColorResources.getPrimary(context)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    isOpen ? 'OPEN' : 'CLOSED',
                    style: titilliumSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: ColorResources.getPrimary(context),
                  size: 16,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  ticket.type,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Icon(
                  Icons.flag,
                  color: ColorResources.getPrimary(context),
                  size: 16,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  ticket.priority,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Text(
              ticket.description,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_SMALL,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'View Details',
                  style: titilliumSemiBold.copyWith(
                    color: ColorResources.getPrimary(context),
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ColorResources.getPrimary(context),
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          Text(
            'No Support Tickets',
            style: titilliumBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Text(
            'You haven\'t created any support tickets yet.',
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SupportTicketShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: ColorResources.IMAGE_BG,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorResources.SELLER_TXT, width: 2),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled:
            Provider.of<SupportTicketProvider>(context).supportTicketList ==
                null,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 10, width: 100, color: ColorResources.WHITE),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Container(height: 15, color: ColorResources.WHITE),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Container(height: 15, width: 15, color: ColorResources.WHITE),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Container(height: 15, width: 50, color: ColorResources.WHITE),
                Expanded(child: SizedBox.shrink()),
                Container(height: 30, width: 70, color: ColorResources.WHITE),
              ]),
            ]),
          ),
        );
      },
    );
  }
}
